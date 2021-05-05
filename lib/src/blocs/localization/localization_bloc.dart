import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:capstone_mobile/generated/l10n.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, String> {
  LocalizationBloc() : super('en_US');

  @override
  Stream<String> mapEventToState(
    LocalizationEvent event,
  ) async* {
    if (event is LocalizationUpdated) {
      S.load(Locale(event.languageCode, ''));

      yield event.languageCode;
    }
  }
}
