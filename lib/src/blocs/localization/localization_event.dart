part of 'localization_bloc.dart';

abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class LocalizationUpdated extends LocalizationEvent {
  final String languageCode;

  LocalizationUpdated(this.languageCode);

  @override
  List<Object> get props => [languageCode];

  @override
  String toString() => 'LocalizationUpdated { tab: $languageCode }';
}
