import 'package:aplikasi_asabri_nullsafety/data/models/User_model.dart';

class RequestModel {
  bool isSucces;
  User? data;
  String? message;

  RequestModel({required this.isSucces, this.data, this.message});
}
