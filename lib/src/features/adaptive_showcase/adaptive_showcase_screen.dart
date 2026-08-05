// A full showcase that relies entirely on `adaptive_platform_ui`.
// Every widget here comes from the package so the UI renders natively:
// Material on Android, Cupertino / iOS 26 liquid-glass on iOS.

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

enum _Plan { free, pro, team }

class AdaptiveShowcaseScreen extends StatefulWidget {
  const AdaptiveShowcaseScreen({super.key});

  @override
  State<AdaptiveShowcaseScreen> createState() => _AdaptiveShowcaseScreenState();
}

class _AdaptiveShowcaseScreenState extends State<AdaptiveShowcaseScreen> {
  int _tab = 0;

  // Control states
  bool _switchValue = true;
  bool? _checkboxValue = true;
  double _sliderValue = 0.4;
  int _segment = 0;
  _Plan _plan = _Plan.free;
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _controlsPage(context),
      const _FormPage(),
      _tabsPage(context),
    ];

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        title: 'Adaptive UI',
        subtitle: 'adaptive_platform_ui',
        actions: [
          AdaptiveAppBarAction(
            icon: Icons.info_outline,
            iosSymbol: 'info.circle',
            onPressed: () => _showAlert(context),
          ),
        ],
      ),
      floatingActionButton: AdaptiveFloatingActionButton(
        onPressed: () => AdaptiveSnackBar.show(
          context,
          message: 'FloatingActionButton pressed',
          type: AdaptiveSnackBarType.success,
        ),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AdaptiveBottomNavigationBar(
        selectedIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          AdaptiveNavigationDestination(icon: Icons.widgets, label: 'Controls'),
          AdaptiveNavigationDestination(icon: Icons.edit_note, label: 'Form'),
          AdaptiveNavigationDestination(icon: Icons.tab, label: 'Tabs'),
        ],
      ),
      body: pages[_tab],
    );
  }

  // ---------------------------------------------------------------- Controls
  Widget _controlsPage(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section('Buttons', [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AdaptiveButton(onPressed: () {}, label: 'Filled'),
              AdaptiveButton(
                onPressed: () {},
                label: 'Tinted',
                style: AdaptiveButtonStyle.tinted,
              ),
              AdaptiveButton.icon(onPressed: () {}, icon: Icons.favorite),
              AdaptiveButton.child(
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.add, size: 18), Text(' Add item')],
                ),
              ),
            ],
          ),
        ]),
        _section('Switch · Checkbox · Slider', [
          AdaptiveListTile(
            title: const Text('Switch'),
            trailing: AdaptiveSwitch(
              value: _switchValue,
              onChanged: (v) => setState(() => _switchValue = v),
            ),
          ),
          AdaptiveListTile(
            title: const Text('Checkbox (tristate)'),
            trailing: AdaptiveCheckbox(
              value: _checkboxValue,
              tristate: true,
              onChanged: (v) => setState(() => _checkboxValue = v),
            ),
          ),
          AdaptiveSlider(
            value: _sliderValue,
            onChanged: (v) => setState(() => _sliderValue = v),
          ),
        ]),
        _section('Segmented control', [
          AdaptiveSegmentedControl(
            labels: const ['Day', 'Week', 'Month'],
            selectedIndex: _segment,
            onValueChanged: (i) => setState(() => _segment = i),
          ),
        ]),
        _section('Radio', [
          for (final p in _Plan.values)
            AdaptiveListTile(
              title: Text(p.name),
              onTap: () => setState(() => _plan = p),
              trailing: AdaptiveRadio<_Plan>(
                value: p,
                groupValue: _plan,
                onChanged: (v) => setState(() => _plan = v ?? _plan),
              ),
            ),
        ]),
        _section('Badge · Tooltip', [
          Row(
            children: [
              const AdaptiveBadge(count: 5, child: Icon(Icons.notifications)),
              const SizedBox(width: 24),
              const AdaptiveBadge(
                label: 'NEW',
                backgroundColor: Colors.red,
                child: Icon(Icons.mail),
              ),
              const SizedBox(width: 24),
              AdaptiveTooltip(
                message: 'This is an adaptive tooltip',
                child: const Icon(Icons.help_outline),
              ),
            ],
          ),
        ]),
        _section('List tile · Context menu', [
          AdaptiveContextMenu(
            actions: [
              AdaptiveContextMenuAction(
                title: 'Edit',
                icon: Icons.edit,
                onPressed: () {},
              ),
              AdaptiveContextMenuAction(
                title: 'Delete',
                icon: Icons.delete,
                isDestructive: true,
                onPressed: () {},
              ),
            ],
            child: AdaptiveListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Long-press me'),
              subtitle: const Text('Opens an adaptive context menu'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ]),
        _section('Popup menu', [
          AdaptivePopupMenuButton.text<String>(
            label: 'Options',
            items: [
              const AdaptivePopupMenuItem(
                label: 'Share',
                icon: Icons.share,
                value: 'share',
              ),
              const AdaptivePopupMenuItem(
                label: 'Rename',
                icon: Icons.drive_file_rename_outline,
                value: 'rename',
              ),
              const AdaptivePopupMenuDivider(),
              const AdaptivePopupMenuItem(
                label: 'Delete',
                icon: Icons.delete,
                value: 'delete',
              ),
            ],
            onSelected: (index, item) => AdaptiveSnackBar.show(
              context,
              message: 'Selected: ${item.value}',
              type: AdaptiveSnackBarType.info,
            ),
          ),
        ]),
        _section('Expansion tile', [
          AdaptiveExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('Advanced settings'),
            subtitle: const Text('Tap to expand'),
            children: const [
              ListTile(title: Text('Option 1')),
              ListTile(title: Text('Option 2')),
            ],
          ),
        ]),
        _section('Dialogs & pickers', [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AdaptiveButton(
                onPressed: () => _showAlert(context),
                label: 'Alert dialog',
                style: AdaptiveButtonStyle.tinted,
              ),
              AdaptiveButton(
                onPressed: () => _pickDate(context),
                label: _pickedDate == null
                    ? 'Date picker'
                    : '${_pickedDate!.year}/${_pickedDate!.month}/${_pickedDate!.day}',
                style: AdaptiveButtonStyle.tinted,
              ),
              AdaptiveButton(
                onPressed: () => _pickTime(context),
                label: _pickedTime == null
                    ? 'Time picker'
                    : _pickedTime!.format(context),
                style: AdaptiveButtonStyle.tinted,
              ),
              AdaptiveButton(
                onPressed: () => AdaptiveSnackBar.show(
                  context,
                  message: 'File deleted',
                  type: AdaptiveSnackBarType.info,
                  action: 'Undo',
                  onActionPressed: () {},
                ),
                label: 'Snackbar',
                style: AdaptiveButtonStyle.tinted,
              ),
            ],
          ),
        ]),
      ],
    );
  }

  Widget _section(String title, List<Widget> children) {
    return AdaptiveCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  // -------------------------------------------------------------------- Tabs
  Widget _tabsPage(BuildContext context) {
    return AdaptiveTabBarView(
      tabs: const ['Latest', 'Popular', 'Trending'],
      children: [
        _tabList('Latest', Icons.new_releases),
        _tabList('Popular', Icons.star),
        _tabList('Trending', Icons.trending_up),
      ],
    );
  }

  Widget _tabList(String label, IconData icon) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var i = 1; i <= 6; i++)
          AdaptiveListTile(
            leading: Icon(icon),
            title: Text('$label item $i'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
      ],
    );
  }

  // ----------------------------------------------------------------- Helpers
  Future<void> _showAlert(BuildContext context) async {
    await AdaptiveAlertDialog.show(
      context: context,
      title: 'Adaptive UI',
      message: 'This entire screen relies on adaptive_platform_ui.',
      icon: 'checkmark.circle.fill',
      actions: [
        AlertAction(
          title: 'Cancel',
          style: AlertActionStyle.cancel,
          onPressed: () {},
        ),
        AlertAction(
          title: 'Great',
          style: AlertActionStyle.primary,
          onPressed: () {},
        ),
      ],
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final date = await AdaptiveDatePicker.show(
      context: context,
      initialDate: _pickedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _pickedDate = date);
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await AdaptiveTimePicker.show(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => _pickedTime = time);
  }
}

// --------------------------------------------------------------------- Form
// Emphasised: AdaptiveTextFormField inside AdaptiveFormSection with validation.
class _FormPage extends StatefulWidget {
  const _FormPage();

  @override
  State<_FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<_FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          AdaptiveFormSection.insetGrouped(
            header: const Text('Contact details'),
            footer: const Text('All fields are validated on submit.'),
            children: [
              AdaptiveTextFormField(
                controller: _nameCtrl,
                placeholder: 'Full name',
                prefixIcon: const Icon(Icons.person_outline),
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              AdaptiveTextFormField(
                controller: _emailCtrl,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.mail_outline),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              AdaptiveTextFormField(
                controller: _phoneCtrl,
                placeholder: 'Phone',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (v) => (v == null || v.length < 7)
                    ? 'Enter a valid phone number'
                    : null,
              ),
            ],
          ),
          AdaptiveFormSection.insetGrouped(
            header: const Text('Security'),
            children: [
              AdaptiveTextFormField(
                placeholder: 'Password',
                obscureText: _obscure,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                validator: (v) => (v == null || v.length < 6)
                    ? 'At least 6 characters'
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AdaptiveTextField(
              placeholder: 'Search (plain AdaptiveTextField)',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: AdaptiveButton(
                onPressed: _submit,
                label: 'Submit',
                size: AdaptiveButtonSize.large,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      AdaptiveSnackBar.show(
        context,
        message: 'Form is valid ✓',
        type: AdaptiveSnackBarType.success,
      );
    } else {
      AdaptiveSnackBar.show(
        context,
        message: 'Please fix the errors',
        type: AdaptiveSnackBarType.error,
      );
    }
  }
}
