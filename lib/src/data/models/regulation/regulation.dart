import 'package:equatable/equatable.dart';

class Regulation extends Equatable {
  final int id;
  final String name;

  Regulation({
    this.id,
    this.name,
  });

  @override
  List<Object> get props => [name, id];

  static Regulation fromJson(dynamic json) {
    return Regulation(
      id: json['id'],
      name: json['name'],
    );
  }
}
