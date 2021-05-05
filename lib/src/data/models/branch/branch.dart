import 'package:equatable/equatable.dart';

class Branch extends Equatable {
  final int id;
  final String name;

  Branch({
    this.id,
    this.name,
  });

  @override
  List<Object> get props => [name, id];

  static Branch fromJson(dynamic json) {
    return Branch(
      id: json['id'],
      name: json['name'],
    );
  }
}
