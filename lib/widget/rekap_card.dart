import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/cubit/rekap_cubit.dart';
import 'package:aplikasi_asabri_nullsafety/data/model/rekap_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RekapCard extends StatelessWidget {
  final RekapModel rekap;
  const RekapCard(this.rekap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<RekapCubit, RekapState>(
        builder: (context, state) {
          if (state is RekapSuccess) {
            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: Text(
                        'Nama',
                        style: blackTextStyle,
                      ),
                    ),
                    Text(' : '),
                    Expanded(
                      child: Text(
                        rekap.name,
                        style: blackTextStyle,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: Text(
                        'Tanggal',
                        style: blackTextStyle,
                      ),
                    ),
                    Text(' : '),
                    Expanded(
                      child: Text(
                        rekap.date,
                        style: blackTextStyle,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: Text(
                        'Jam Absen',
                        style: blackTextStyle,
                      ),
                    ),
                    Text(' : '),
                    Expanded(
                      child: Text(
                        rekap.jam + '.' + rekap.menit,
                        style: blackTextStyle,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: Text(
                        'Alamat',
                        style: blackTextStyle,
                      ),
                    ),
                    Text(' : '),
                    Expanded(
                      child: Text(
                        rekap.alamat,
                        style: blackTextStyle,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      child: Text(
                        'Jenis Absen',
                        style: blackTextStyle,
                      ),
                    ),
                    Text(' : '),
                    Expanded(
                      child: Text(
                        rekap.jenisAbsen,
                        style: rekap.jenisAbsen == 'Masuk'
                            ? greenTextStyle
                            : redTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
          return Text('Rekap Absen');
        },
      ),
    );
  }
}
