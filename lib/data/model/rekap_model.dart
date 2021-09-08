import 'package:equatable/equatable.dart';

class RekapModel extends Equatable {
  final String name;
  final int nipas;
  final String divisi;
  final String statusKerja;
  final String alasanWfh;
  final String keKantorMenggunakan;
  final String kondisiKesehatan;
  final String jenisAbsen;
  final String alamat;
  final String image;
  final String date;
  final String jam;
  final String menit;

  RekapModel({
    required this.name,
    required this.nipas,
    required this.divisi,
    required this.statusKerja,
    this.alasanWfh = '',
    this.keKantorMenggunakan = '',
    this.kondisiKesehatan = '',
    required this.jenisAbsen,
    required this.alamat,
    this.image = '',
    this.date = '',
    this.jam = '',
    this.menit = '',
  });

  factory RekapModel.fromJson(String id, Map<String, dynamic> json) =>
      RekapModel(
        name: json['name'],
        nipas: json['nipas'],
        divisi: json['divisi'],
        statusKerja: json['statusKerja'],
        alasanWfh: json['alasanWfh'],
        keKantorMenggunakan: json['keKantorMenggunakan'],
        kondisiKesehatan: json['kondisiKesehatan'],
        jenisAbsen: json['jenisAbsen'],
        alamat: json['alamat'],
        image: json['image'],
        date: json['date'].toString(),
        jam: json['jam'].toString(),
        menit: json['menit'].toString(),
      );

  @override
  List<Object?> get props => [
        name,
        nipas,
        divisi,
        statusKerja,
        alasanWfh,
        keKantorMenggunakan,
        kondisiKesehatan,
        jenisAbsen,
        alamat,
        image,
        date,
        jam,
        menit,
      ];
}
