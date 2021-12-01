import 'dart:convert';
import 'dart:io';

import 'package:aplikasi_asabri_nullsafety/data/models/Absen_model.dart';
import 'package:aplikasi_asabri_nullsafety/data/models/Login_model.dart';
import 'package:aplikasi_asabri_nullsafety/data/models/User_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.137.1:3000/';

  Future<User> addUser(User user) async {
    final response = await http.post(
      Uri.parse(_baseUrl + 'register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'username': user.username,
        'password': user.password,
        'name': user.name,
        'divisi': user.divisi,
        'divisiid': user.divisiid,
        'nip': user.nip,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('gagal register');
    }
  }

  Future<GetUser> getUser(GetUser user) async {
    final response = await http.post(
      Uri.parse(_baseUrl + 'login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'username': user.username,
        'password': user.password,
      }),
    );

    if (response.statusCode == 200) {
      return GetUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('gagal login');
    }
  }

  Future<AbsenModel> saveWithImage(AbsenModel absen, File? imageFile) async {
    var uri = Uri.parse(_baseUrl + 'addAbsen');

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    if (imageFile != null) {
      var stream = new http.ByteStream(imageFile.openRead())..cast();
      // get file length
      var length = await imageFile.length();
      var multipartFileSign = new http.MultipartFile('doc', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFileSign);
      request.fields['name'] = absen.docName!;
      request.fields['size'] = absen.docSize.toString();
    }

    // multipart that takes file

    //add headers
    // request.headers.addAll(headers);

    //adding params
    request.fields['nip'] = absen.nipas!;
    request.fields['divisi'] = absen.divisi!;
    request.fields['status'] = absen.status.toString();
    request.fields['alasan'] = absen.alasan.toString();
    request.fields['transportasi'] = absen.transportasi.toString();
    request.fields['kondisi'] = absen.kondisi.toString();
    request.fields['jenis'] = absen.jenis.toString();
    request.fields['latitude'] = absen.latitude.toString();
    request.fields['longitude'] = absen.longitude.toString();
    request.fields['username'] = absen.username!;
    request.fields['userdate'] = absen.userdate!;
    request.fields['suhu'] = absen.suhu!;
    request.fields['address'] = absen.address!;
    request.fields['other'] = absen.other!;
    request.fields['divisiid'] = absen.divisiid.toString();
    request.fields['zona'] = absen.zona!;
    request.fields['dateAbsen'] = absen.dateAbsen!;
    request.fields['kegiatan'] = absen.kegiatan!;

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
