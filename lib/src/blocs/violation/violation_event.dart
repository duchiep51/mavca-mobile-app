part of 'violation_bloc.dart';

abstract class ViolationEvent extends Equatable {
  const ViolationEvent();

  @override
  List<Object> get props => [];
}

class ViolationRequested extends ViolationEvent {
  const ViolationRequested({
    this.isRefresh = false,
  });

  final bool isRefresh;

  @override
  List<Object> get props => [isRefresh];

  @override
  String toString() => ' ViolationRequested: {  $isRefresh }';
}

class FilterChanged extends ViolationEvent {
  const FilterChanged({
    this.filter,
  });

  final Filter filter;

  @override
  List<Object> get props => [filter];

  @override
  String toString() => ' FilterChanged: { ${filter.toString()} } ';
}

class ViolationUpdate extends ViolationEvent {
  const ViolationUpdate({this.violation});

  final Violation violation;

  @override
  List<Object> get props => [violation];
}

class ViolationDelete extends ViolationEvent {
  const ViolationDelete({
    @required this.token,
    @required this.id,
  });

  final String token;
  final int id;

  @override
  List<Object> get props => [token, id];
}

class ViolationAuthenticationStatusChanged extends ViolationEvent {
  const ViolationAuthenticationStatusChanged({this.status});

  final AuthenticationStatus status;

  @override
  List<Object> get props => [status];
}
