part of 'regulation_bloc.dart';

abstract class RegulationEvent extends Equatable {
  const RegulationEvent();

  @override
  List<Object> get props => [];
}

class RegulationRequested extends RegulationEvent {
  final String token;

  RegulationRequested({@required this.token});

  @override
  List<Object> get props => [token];

  @override
  String toString() => ' RegulationRequested ';
}
