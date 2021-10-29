import 'dart:convert';
import 'dart:io';

import 'package:aplikasi_asabri_nullsafety/data/models/Absen_model.dart';
import 'package:aplikasi_asabri_nullsafety/data/models/Rekap_model.dart';
import 'package:aplikasi_asabri_nullsafety/data/models/User_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiService {
  final String _baseUrl = 'https://dev-absensi.asabri.co.id/api/';

  Future<User> fetchSharp(String token) async {
    var response = await http.get(Uri.parse(_baseUrl + 'user/getuser'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + token});
    return User.fromJson(jsonDecode(response.body));
  }

  Future<List<HistoriAbsen>> getListUser(String token) async {
    var response = await http.get(
        Uri.parse(_baseUrl + 'user/getlistabsen/0/10'),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + token});
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      List<dynamic> jsonResponse = map["data"];
      return jsonResponse
          .map((rekap) => new HistoriAbsen.fromJson(rekap))
          .toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<AbsenModel> saveWithImage(
      AbsenModel absen, String token, File? imageFile) async {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    };
    var uri = Uri.parse(_baseUrl + 'user/save');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    if (imageFile != null) {
      var stream = new http.ByteStream(imageFile.openRead())..cast();
      // get file length
      var length = await imageFile.length();
      var multipartFileSign = new http.MultipartFile('AbsDoc', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFileSign);
      request.fields['AbsDocName'] = absen.absDocName!;
      request.fields['AbsDocSize'] = absen.absDocSize.toString();
    }

    // multipart that takes file

    //add headers
    request.headers.addAll(headers);

    //adding params
    request.fields['AbsNipas'] = absen.absNipas!;
    request.fields['AbsDivisi'] = absen.absDivisi!;
    request.fields['AbsStatus'] = absen.absStatus.toString();
    request.fields['AbsAlasan'] = absen.absAlasan.toString();
    request.fields['AbsTransportasi'] = absen.absTransportasi.toString();
    request.fields['AbsKondisi'] = absen.absKondisi.toString();
    request.fields['AbsJenis'] = absen.absJenis.toString();
    request.fields['AbsLatitude'] = absen.absLatitude.toString();
    request.fields['AbsLongitude'] = absen.absLongitude.toString();
    request.fields['AbsUsrnam'] = absen.absUsrnam!;
    request.fields['AbsUsrdat'] = absen.absUsrdat!;
    request.fields['AbsSuhu'] = absen.absSuhu!;
    request.fields['AbsAddress'] = absen.absAddress!;
    request.fields['AbsOther'] = absen.absOther!;
    request.fields['Divisiid'] = absen.divisiid.toString();
    request.fields['AbsZona'] = absen.absZona!;
    request.fields['AbsDateAbsen'] = absen.absDateAbsen.toString();
    request.fields['AbsKegiatan'] = absen.absKegiatan!;

    // send
    var response = await request.send();

    final res = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return AbsenModel.fromJson(jsonDecode(res.body));
    } else if (response.statusCode == 400) {
      return AbsenModel.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed for absen');
    }
  }
}
