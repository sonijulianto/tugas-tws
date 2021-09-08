import 'package:aplikasi_asabri_nullsafety/data/model/rekap_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RekapService {
  CollectionReference _rekapReference =
      FirebaseFirestore.instance.collection('absens');

  Future<RekapModel?> rekapAbsen({
    required String name,
    required int nipas,
    required String divisi,
    required String statusKerja,
    final String alasanWfh = '',
    final String keKantorMenggunakan = '',
    final String kondisiKesehatan = '',
    required String jenisAbsen,
    required String alamat,
    final String image = '',
    final String date = '',
    final String jam = '',
    final String menit = '',
  }) async {
    try {
      RekapModel rekap = RekapModel(
        name: name,
        nipas: nipas,
        divisi: divisi,
        statusKerja: statusKerja,
        alasanWfh: alasanWfh,
        keKantorMenggunakan: keKantorMenggunakan,
        kondisiKesehatan: kondisiKesehatan,
        jenisAbsen: jenisAbsen,
        alamat: alamat,
        image: image,
        date: date,
        jam: jam,
        menit: menit,
      );
      await RekapService().setAbsen(rekap);
      return rekap;
    } catch (e) {
      throw e;
    }
  }

  Future<void> setAbsen(RekapModel rekap) async {
    try {
      _rekapReference
          .doc('${rekap.name} ${DateTime.now().day} ${rekap.jenisAbsen}')
          .set({
        'name': rekap.name,
        'nipas': rekap.nipas,
        'divisi': rekap.divisi,
        'statusKerja': rekap.statusKerja,
        'alasanWfh': rekap.alasanWfh,
        'keKantorMenggunakan': rekap.keKantorMenggunakan,
        'kondisiKesehatan': rekap.kondisiKesehatan,
        'jenisAbsen': rekap.jenisAbsen,
        'alamat': rekap.alamat,
        'image': rekap.image,
        'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'jam': DateTime.now().hour,
        'menit': DateTime.now().minute,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<List<RekapModel>> fetchRekap() async {
    try {
      QuerySnapshot result = await _rekapReference.get();

      List<RekapModel> rekaps = result.docs.map(
        (e) {
          return RekapModel.fromJson(e.id, e.data() as Map<String, dynamic>);
        },
      ).toList();
      return rekaps;
    } catch (e) {
      throw e;
    }
  }
}
