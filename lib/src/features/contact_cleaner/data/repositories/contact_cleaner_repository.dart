// ignore_for_file: cascade_invocations, lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types, package_api_docs
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'dart:io';

import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/models/contact_cleaner_models.dart';
import 'package:path_provider/path_provider.dart';

class ContactRepository {
  static const Set<ContactProperty> scanProperties = <ContactProperty>{
    ContactProperty.name,
    ContactProperty.phone,
  };

  static const Set<ContactProperty> fullProperties = <ContactProperty>{
    ContactProperty.name,
    ContactProperty.phone,
    ContactProperty.email,
    ContactProperty.address,
    ContactProperty.organization,
    ContactProperty.website,
    ContactProperty.socialMedia,
    ContactProperty.event,
    ContactProperty.relation,
    ContactProperty.note,
    ContactProperty.photoThumbnail,
    ContactProperty.photoFullRes,
  };

  Future<PermissionStatus> requestPermission() {
    return FlutterContacts.permissions.request(PermissionType.readWrite);
  }

  Future<void> openSettings() {
    return FlutterContacts.permissions.openSettings();
  }

  Future<List<Contact>> fetchScanContacts() {
    return FlutterContacts.getAll(properties: scanProperties);
  }

  Future<Contact?> fetchFullContact(String contactId) {
    return FlutterContacts.get(contactId, properties: fullProperties);
  }

  Future<String> exportBackupFile() async {
    final List<Contact> contacts = await FlutterContacts.getAll(
      properties: fullProperties,
    );
    final String vCard = FlutterContacts.vCard.exportAll(contacts);
    final Directory directory = await getApplicationDocumentsDirectory();
    final DateTime now = DateTime.now();
    final String timestamp =
        _twoDigits(now.year) +
        _twoDigits(now.month) +
        _twoDigits(now.day) +
        '-' +
        _twoDigits(now.hour) +
        _twoDigits(now.minute) +
        _twoDigits(now.second);
    final String path = '${directory.path}/contact-backup-$timestamp.vcf';
    final File file = File(path);
    await file.writeAsString(vCard);
    return path;
  }

  Future<void> applyPlan(
    CleanupPlan plan,
    Map<String, Contact> scannedContactsById,
  ) async {
    final Set<String> mergedContactIds = plan.mergePlans
        .expand((MergePlan mergePlan) => mergePlan.contactIds)
        .toSet();

    for (final MergePlan mergePlan in plan.mergePlans) {
      await _applyMergePlan(mergePlan, plan);
    }

    final List<Contact> contactsToUpdate = <Contact>[];
    for (final ContactCleanupPlanEntry contactPlan in plan.contactPlans) {
      if (!contactPlan.hasChanges ||
          mergedContactIds.contains(contactPlan.contactId)) {
        continue;
      }
      // IMPORTANT: fetch the FULL contact (emails, addresses, photo, notes…)
      // before updating. Updating from the scan-only copy (name + phone) would
      // wipe every other field. Fall back to the scan copy only if the full
      // fetch fails.
      final Contact? sourceContact =
          await fetchFullContact(contactPlan.contactId) ??
          scannedContactsById[contactPlan.contactId];
      if (sourceContact == null) {
        continue;
      }
      final Contact updatedContact = _applyPhoneChanges(
        sourceContact,
        contactPlan,
      );
      contactsToUpdate.add(updatedContact);
    }

    if (contactsToUpdate.isNotEmpty) {
      await FlutterContacts.updateAll(contactsToUpdate);
    }
  }

  Future<void> _applyMergePlan(MergePlan mergePlan, CleanupPlan plan) async {
    final List<Contact?> fetchedContacts = await Future.wait<Contact?>(
      mergePlan.contactIds.map(fetchFullContact),
    );
    final Map<String, Contact> contactsById = <String, Contact>{};
    for (final Contact? contact in fetchedContacts) {
      if (contact?.id != null) {
        contactsById[contact!.id!] = contact;
      }
    }

    final Contact? primaryContact = contactsById[mergePlan.primaryContactId];
    if (primaryContact == null) {
      return;
    }

    final List<Contact> secondaryContacts = mergePlan.secondaryContactIds
        .map((String id) => contactsById[id])
        .whereType<Contact>()
        .toList();

    final List<Phone> mergedPhones = _buildMergedPhones(
      mergePlan: mergePlan,
      plan: plan,
      contactsById: contactsById,
    );
    final Contact mergedContact = primaryContact.copyWith(
      name: _pickMergedName(primaryContact, secondaryContacts),
      phones: mergedPhones,
      emails: _mergeEmails(primaryContact, secondaryContacts),
      addresses: _mergeAddresses(primaryContact, secondaryContacts),
      organizations: _mergeOrganizations(primaryContact, secondaryContacts),
      websites: _mergeWebsites(primaryContact, secondaryContacts),
      socialMedias: _mergeSocialMedia(primaryContact, secondaryContacts),
      events: _mergeEvents(primaryContact, secondaryContacts),
      relations: _mergeRelations(primaryContact, secondaryContacts),
      notes: _mergeNotes(primaryContact, secondaryContacts),
      photo: _pickMergedPhoto(primaryContact, secondaryContacts),
    );

    await FlutterContacts.update(mergedContact);
    if (mergePlan.secondaryContactIds.isNotEmpty) {
      await FlutterContacts.deleteAll(mergePlan.secondaryContactIds);
    }
  }

  Contact _applyPhoneChanges(
    Contact sourceContact,
    ContactCleanupPlanEntry planEntry,
  ) {
    final List<Phone> phones = <Phone>[];
    for (final PlannedPhoneChange change in planEntry.phoneChanges) {
      if (change.entryIndex >= sourceContact.phones.length) {
        continue;
      }
      final Phone phone = sourceContact.phones[change.entryIndex];
      // Safety guard: if the phone at this position no longer matches the
      // number we analyzed (order/content drifted since the scan), keep it
      // untouched instead of risking a wrong edit or deletion.
      final bool matchesAnalyzed = phone.number == change.originalNumber;
      if (!change.keep) {
        if (matchesAnalyzed) {
          continue; // safe to remove
        }
        phones.add(phone); // drifted: keep it, do not delete
        continue;
      }
      if (change.needsReplacement && matchesAnalyzed) {
        phones.add(phone.copyWith(number: change.replacementNumber));
      } else {
        phones.add(phone);
      }
    }
    return sourceContact.copyWith(phones: phones);
  }

  List<Phone> _buildMergedPhones({
    required MergePlan mergePlan,
    required CleanupPlan plan,
    required Map<String, Contact> contactsById,
  }) {
    final Set<String> seenKeys = <String>{};
    final List<Phone> mergedPhones = <Phone>[];

    void addPhonesForContact(
      String contactId, {
      required bool preserveMetadata,
    }) {
      final Contact? contact = contactsById[contactId];
      final ContactCleanupPlanEntry? planEntry = plan.findContactPlan(
        contactId,
      );
      if (contact == null || planEntry == null) {
        return;
      }

      for (final PlannedPhoneChange change in planEntry.phoneChanges) {
        if (!change.keep || change.entryIndex >= contact.phones.length) {
          continue;
        }
        final String deduplicationKey = change.deduplicationKey.isEmpty
            ? '$contactId::${change.entryIndex}'
            : change.deduplicationKey;
        if (!seenKeys.add(deduplicationKey)) {
          continue;
        }
        final Phone phone = contact.phones[change.entryIndex];
        // Only apply the normalized replacement when the phone still matches
        // what we analyzed; otherwise keep the current number untouched.
        final String? replacement = phone.number == change.originalNumber
            ? change.replacementNumber
            : null;
        if (preserveMetadata) {
          mergedPhones.add(
            phone.copyWith(number: replacement ?? phone.number),
          );
        } else {
          mergedPhones.add(_detachPhone(phone, replacement));
        }
      }
    }

    addPhonesForContact(mergePlan.primaryContactId, preserveMetadata: true);
    for (final String contactId in mergePlan.secondaryContactIds) {
      addPhonesForContact(contactId, preserveMetadata: false);
    }

    return mergedPhones;
  }

  Name? _pickMergedName(Contact primary, List<Contact> secondaryContacts) {
    if (_hasUsableName(primary.name)) {
      return primary.name;
    }
    for (final Contact contact in secondaryContacts) {
      if (_hasUsableName(contact.name)) {
        return _cloneName(contact.name!);
      }
    }
    return primary.name;
  }

  Photo? _pickMergedPhoto(Contact primary, List<Contact> secondaryContacts) {
    if (primary.photo?.fullSize != null || primary.photo?.thumbnail != null) {
      return primary.photo;
    }
    for (final Contact contact in secondaryContacts) {
      if (contact.photo?.fullSize != null || contact.photo?.thumbnail != null) {
        return _clonePhoto(contact.photo!);
      }
    }
    return primary.photo;
  }

  List<Email> _mergeEmails(Contact primary, List<Contact> secondaryContacts) {
    return _mergePropertyList<Email>(
      primaryItems: primary.emails,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.emails,
      detach: _detachEmail,
      keyOf: (Email email) => email.address.trim().toLowerCase(),
    );
  }

  List<Address> _mergeAddresses(
    Contact primary,
    List<Contact> secondaryContacts,
  ) {
    return _mergePropertyList<Address>(
      primaryItems: primary.addresses,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.addresses,
      detach: _detachAddress,
      keyOf: (Address address) =>
          _jsonKey(address.toJson(), stripMetadata: true),
    );
  }

  List<Organization> _mergeOrganizations(
    Contact primary,
    List<Contact> secondaryContacts,
  ) {
    return _mergePropertyList<Organization>(
      primaryItems: primary.organizations,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.organizations,
      detach: _detachOrganization,
      keyOf: (Organization organization) =>
          _jsonKey(organization.toJson(), stripMetadata: true),
    );
  }

  List<Website> _mergeWebsites(
    Contact primary,
    List<Contact> secondaryContacts,
  ) {
    return _mergePropertyList<Website>(
      primaryItems: primary.websites,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.websites,
      detach: _detachWebsite,
      keyOf: (Website website) =>
          _jsonKey(website.toJson(), stripMetadata: true),
    );
  }

  List<SocialMedia> _mergeSocialMedia(
    Contact primary,
    List<Contact> secondaryContacts,
  ) {
    return _mergePropertyList<SocialMedia>(
      primaryItems: primary.socialMedias,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.socialMedias,
      detach: _detachSocialMedia,
      keyOf: (SocialMedia item) => _jsonKey(item.toJson(), stripMetadata: true),
    );
  }

  List<Event> _mergeEvents(Contact primary, List<Contact> secondaryContacts) {
    return _mergePropertyList<Event>(
      primaryItems: primary.events,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.events,
      detach: _detachEvent,
      keyOf: (Event item) => _jsonKey(item.toJson(), stripMetadata: true),
    );
  }

  List<Relation> _mergeRelations(
    Contact primary,
    List<Contact> secondaryContacts,
  ) {
    return _mergePropertyList<Relation>(
      primaryItems: primary.relations,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.relations,
      detach: _detachRelation,
      keyOf: (Relation item) => _jsonKey(item.toJson(), stripMetadata: true),
    );
  }

  List<Note> _mergeNotes(Contact primary, List<Contact> secondaryContacts) {
    return _mergePropertyList<Note>(
      primaryItems: primary.notes,
      secondaryContacts: secondaryContacts,
      selector: (Contact contact) => contact.notes,
      detach: _detachNote,
      keyOf: (Note item) => _jsonKey(item.toJson(), stripMetadata: true),
    );
  }

  List<T> _mergePropertyList<T>({
    required List<T> primaryItems,
    required List<Contact> secondaryContacts,
    required List<T> Function(Contact contact) selector,
    required T Function(T item) detach,
    required String Function(T item) keyOf,
  }) {
    final Set<String> seenKeys = <String>{};
    final List<T> items = <T>[];

    for (final T item in primaryItems) {
      final String key = keyOf(item);
      if (seenKeys.add(key)) {
        items.add(item);
      }
    }

    for (final Contact contact in secondaryContacts) {
      for (final T item in selector(contact)) {
        final String key = keyOf(item);
        if (seenKeys.add(key)) {
          items.add(detach(item));
        }
      }
    }

    return items;
  }

  bool _hasUsableName(Name? name) {
    if (name == null) {
      return false;
    }
    return <String?>[
      name.first,
      name.middle,
      name.last,
      name.nickname,
      name.prefix,
      name.suffix,
    ].any((String? value) => value != null && value.trim().isNotEmpty);
  }

  Phone _detachPhone(Phone phone, String? replacementNumber) {
    final Map<String, dynamic> json = _strippedJson(phone.toJson());
    if (replacementNumber != null) {
      json['number'] = replacementNumber;
      json['normalizedNumber'] = replacementNumber;
    }
    return Phone.fromJson(json);
  }

  Email _detachEmail(Email email) {
    return Email.fromJson(_strippedJson(email.toJson()));
  }

  Address _detachAddress(Address address) {
    return Address.fromJson(_strippedJson(address.toJson()));
  }

  Organization _detachOrganization(Organization organization) {
    return Organization.fromJson(_strippedJson(organization.toJson()));
  }

  Website _detachWebsite(Website website) {
    return Website.fromJson(_strippedJson(website.toJson()));
  }

  SocialMedia _detachSocialMedia(SocialMedia socialMedia) {
    return SocialMedia.fromJson(_strippedJson(socialMedia.toJson()));
  }

  Event _detachEvent(Event event) {
    return Event.fromJson(_strippedJson(event.toJson()));
  }

  Relation _detachRelation(Relation relation) {
    return Relation.fromJson(_strippedJson(relation.toJson()));
  }

  Note _detachNote(Note note) {
    return Note.fromJson(_strippedJson(note.toJson()));
  }

  Name _cloneName(Name name) {
    return Name.fromJson(Map<String, dynamic>.from(name.toJson()));
  }

  Photo _clonePhoto(Photo photo) {
    return Photo.fromJson(Map<String, dynamic>.from(photo.toJson()));
  }

  Map<String, dynamic> _strippedJson(Map<String, dynamic> input) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(input);
    json.remove('metadata');
    return json;
  }

  String _jsonKey(Map<String, dynamic> input, {required bool stripMetadata}) {
    final Map<String, dynamic> json = stripMetadata
        ? _strippedJson(input)
        : Map<String, dynamic>.from(input);
    return jsonEncode(json);
  }

  String _twoDigits(int value) {
    return value.toString().padLeft(2, '0');
  }
}
