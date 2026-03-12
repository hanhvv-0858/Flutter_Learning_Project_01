import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';

/// Settings screen with language picker (EN / VI).
///
/// Changing language updates all strings app-wide immediately.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _locales = [
    _LocaleOption(code: 'en', flag: '🇺🇸'),
    _LocaleOption(code: 'vi', flag: '🇻🇳'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, _) {
          final currentCode = provider.locale.languageCode;

          return RadioGroup<String>(
            groupValue: currentCode,
            onChanged: (code) {
              if (code != null) provider.setLocale(code);
            },
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    l10n.settingsLanguage,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ..._locales.map((option) {
                  final label = option.code == 'en'
                      ? l10n.settingsEnglish
                      : l10n.settingsVietnamese;

                  return RadioListTile<String>(
                    value: option.code,
                    title: Text('${option.flag}  $label'),
                    selected: currentCode == option.code,
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LocaleOption {
  final String code;
  final String flag;
  const _LocaleOption({required this.code, required this.flag});
}
