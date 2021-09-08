import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final int nipas;
  final String divisi;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.nipas,
    required this.divisi,
  });

  @override
  List<Object?> get props => [id, email, name, nipas, divisi,];
}
