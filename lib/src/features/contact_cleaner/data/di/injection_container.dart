import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_manager/src/features/contact_cleaner/data/repositories/contact_cleaner_repository.dart';

final contactCleanerRepositoryProvider = Provider<ContactRepository>(
  (Ref ref) => ContactRepository(),
);
