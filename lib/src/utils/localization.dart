import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter_localizations/flutter_localizations.dart';

// class MyLocalizations {
//   static MyLocalizations of(BuildContext context) {
//     return Localizations.of<MyLocalizations>(
//       context,
//       MyLocalizations,
//     );
//   }

//   String get appTitle => "Mavca";
// }

// class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
//   @override
//   Future<MyLocalizations> load(Locale locale) =>
//       Future(() => MyLocalizations());

//   @override
//   bool shouldReload(MyLocalizationsDelegate old) => false;

//   @override
//   bool isSupported(Locale locale) =>
//       locale.languageCode.toLowerCase().contains("en");
// }

class MyLocalizations {
  MyLocalizations(this.locale);

  final Locale locale;

  static MyLocalizations of(BuildContext context) {
    return Localizations.of<MyLocalizations>(context, MyLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'LATEST_NOTIFICATION': 'Latest notification',
    },
    'vn': {
      'LATEST_NOTIFICATION': 'Thông báo mới',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['LATEST_NOTIFICATION'];
  }
}

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vn'].contains(locale.languageCode);

  @override
  Future<MyLocalizations> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of MyLocalizations.
    return SynchronousFuture<MyLocalizations>(MyLocalizations(locale));
  }

  @override
  bool shouldReload(MyLocalizationsDelegate old) => false;
}
