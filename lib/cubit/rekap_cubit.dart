import 'package:aplikasi_asabri_nullsafety/data/model/rekap_model.dart';
import 'package:aplikasi_asabri_nullsafety/service/rekap_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rekap_state.dart';

class RekapCubit extends Cubit<RekapState> {
  RekapCubit() : super(RekapInitial());

  void rekapAbsen({
    required String name,
    required int nipas,
    required String divisi,
    required String statusKerja,
    String alasanWfh = '',
    String keKantorMenggunakan = '',
    String kondisiKesehatan = '',
    required String jenisAbsen,
    required String alamat,
    String image = '',
    String date = '',
    String jam = '',
    String menit = '',
  }) async {
    try {
      emit(RekapLoading());
      RekapModel? rekap = await RekapService().rekapAbsen(
        name: name,
        nipas: nipas,
        divisi: divisi,
        statusKerja: statusKerja,
        jenisAbsen: jenisAbsen,
        alamat: alamat,
        alasanWfh: alasanWfh,
        keKantorMenggunakan: keKantorMenggunakan,
        kondisiKesehatan: kondisiKesehatan,
        image: image,
        date: date,
        jam: jam,
        menit: menit,
      );
      emit(RekapSuccess(rekap!));
    } catch (e) {
      emit(RekapFailed(e.toString()));
    }
  }

  void fetchRekap() async {
    try {
      emit(RekapLoading());

      List<RekapModel> rekaps = await RekapService().fetchRekap();

      emit(RekapSuccess(rekaps));
    } catch (e) {
      emit(RekapFailed(e.toString()));
    }
  }
}
