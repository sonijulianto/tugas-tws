import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/cubit/rekap_cubit.dart';
import 'package:aplikasi_asabri_nullsafety/data/model/rekap_model.dart';
import 'package:aplikasi_asabri_nullsafety/widget/rekap_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RekapPage extends StatefulWidget {
  static const rekapTitle = 'Rekap';

  @override
  _RekapPageState createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  @override
  void initState() {
    context.read<RekapCubit>().fetchRekap();
    super.initState();
  }

  Widget rekapContent(List<RekapModel> rekaps) {
    return ListView(
      children: rekaps.map((RekapModel rekap) {
        return RekapCard(rekap);
      }).toList(),
    );
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<RekapCubit, RekapState>(
            listener: (context, state) {
              if (state is RekapFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: redColor,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is RekapSuccess) {
                return Container(
                  child: rekapContent(state.rekaps),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
