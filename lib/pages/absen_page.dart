import 'dart:async';
import 'dart:io';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/data/api/api_service.dart';
import 'package:aplikasi_asabri_nullsafety/data/models/Absen_model.dart';
import 'package:aplikasi_asabri_nullsafety/data/models/Request_model.dart';
import 'package:aplikasi_asabri_nullsafety/data/models/User_model.dart';
import 'package:aplikasi_asabri_nullsafety/main.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_in_page.dart';
import 'package:aplikasi_asabri_nullsafety/provider/preferences_provider.dart';
import 'package:aplikasi_asabri_nullsafety/widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AbsenPage extends StatefulWidget {
  static const absenTitle = 'Absen';
  AbsenPage({Key? key, this.sharedPreferences}) : super(key: key);

  final Future<SharedPreferences>? sharedPreferences;

  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  final AadOAuth oauth = AadOAuth(MyApp.config);

  void logout() async {
    await oauth.logout();
  }

  XFile? _picture;
  File? imageFile;
  int statusKerja = 0;
  int alasanWFH = 0;
  int keKantorMenggunakan = 0;
  int kondisiKesehatan = 0;
  int jenisAbsen = 0;
  double latitude = 0;
  double longitude = 0;
  String alamat = "";
  String username = '';
  String nipas = '';
  String divisi = '';
  int divisiid = 0;

  bool isJailBroken = false;
  bool canMockLocation = false;
  bool isRealDevice = true;
  bool isOnExternalStorage = false;
  bool isSafeDevice = false;

  Position? currentposition;
  String currentAddress = '';
  LatLng? latLng;

  late Future<User> user;
  late Future<RequestModel> response;
  ApiService? _apiService;
  static bool _isLoading = false;

  Future<void> initPlatformState() async {
    if (!mounted) return;
    try {
      isJailBroken = await SafeDevice.isJailBroken;
      canMockLocation = await SafeDevice.canMockLocation;
      isRealDevice = await SafeDevice.isRealDevice;
      isOnExternalStorage = await SafeDevice.isOnExternalStorage;
      isSafeDevice = await SafeDevice.isSafeDevice;
    } catch (error) {
      print(error);
    }

    setState(() {
      isJailBroken = isJailBroken;
      canMockLocation = canMockLocation;
      isRealDevice = isRealDevice;
      isOnExternalStorage = isOnExternalStorage;
      isSafeDevice = isSafeDevice;
    });
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    _picture = picture;
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      } else {}
    });
  }

  Widget _decideImageView() {
    if (imageFile == null)
      return Container(
        alignment: Alignment.center,
        child: Text(
          "No Image Selected",
          style: blackTextStyle.copyWith(
            fontSize: 9,
          ),
        ),
      );
    else
      return Image.file(
        imageFile!,
        width: 150,
        height: 150,
      );
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please enable Your Location Service');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg:
              'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude = position.latitude;
    longitude = position.longitude;

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks[0];

      setState(() {
        currentposition = position;
        latLng = LatLng(position.latitude, position.longitude);
        currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}" ==
                    "Kecamatan Kramat jati, 13630, Indonesia"
                ? "Gedung Asabri Pusat"
                : "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  Widget googleMaps() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.0,
      ),
    );
  }

  void _statusKerja(int value) {
    setState(() {
      statusKerja = value;
    });
  }

  void _alasanWFH(int value) {
    setState(() {
      alasanWFH = value;
    });
  }

  void _keKantorMenggunakan(int value) {
    setState(() {
      keKantorMenggunakan = value;
    });
  }

  void _kondisiKesehatan(int value) {
    setState(() {
      kondisiKesehatan = value;
    });
  }

  void _jenisAbsen(int value) {
    setState(() {
      jenisAbsen = value;
    });
  }

  @override
  void initState() {
    _determinePosition();
    googleMaps();
    response = ApiService().fetchSharp(context, SignInPage.accessToken!);
    _apiService = ApiService();
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                AbsenPage.absenTitle,
                style: whiteTextStyle,
              ),
            ),
            body: FutureBuilder<RequestModel>(
              future: response,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isSucces) {
                    return Container(
                      margin: EdgeInsets.only(
                        right: 30,
                        left: 30,
                      ),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              costumTextForm(
                                snapshot.data!.data!.nama!,
                                snapshot.data!.data!.nipas,
                                snapshot.data!.data!.divisi,
                              ),
                              radioListSK(
                                provider.isDarkTheme
                                    ? greyTextStyle
                                    : textTextStyle,
                                provider.isDarkTheme
                                    ? greyTextStyle.copyWith(
                                        fontWeight: semiBold)
                                    : textTextStyle.copyWith(
                                        fontWeight: semiBold),
                                provider.isDarkTheme ? greyColor : textColor,
                              ),
                              statusKerja == 1
                                  ? radioListWFH(
                                      provider.isDarkTheme
                                          ? greyTextStyle
                                          : textTextStyle,
                                      provider.isDarkTheme
                                          ? greyTextStyle.copyWith(
                                              fontWeight: semiBold)
                                          : textTextStyle.copyWith(
                                              fontWeight: semiBold),
                                      provider.isDarkTheme
                                          ? greyColor
                                          : textColor,
                                    )
                                  : SizedBox(),
                              statusKerja != 0
                                  ? radioListKeKantor(
                                      provider.isDarkTheme
                                          ? greyTextStyle
                                          : textTextStyle,
                                      provider.isDarkTheme
                                          ? greyTextStyle.copyWith(
                                              fontWeight: semiBold)
                                          : textTextStyle.copyWith(
                                              fontWeight: semiBold),
                                      provider.isDarkTheme
                                          ? greyColor
                                          : textColor,
                                    )
                                  : SizedBox(),
                              keKantorMenggunakan != 0
                                  ? radioListKondisiKesehatan(
                                      provider.isDarkTheme
                                          ? greyTextStyle
                                          : textTextStyle,
                                      provider.isDarkTheme
                                          ? greyTextStyle.copyWith(
                                              fontWeight: semiBold)
                                          : textTextStyle.copyWith(
                                              fontWeight: semiBold),
                                      provider.isDarkTheme
                                          ? greyColor
                                          : textColor,
                                    )
                                  : SizedBox(),
                              kondisiKesehatan != 0
                                  ? radioListJenisAbsen(
                                      provider.isDarkTheme
                                          ? greyTextStyle
                                          : textTextStyle,
                                      provider.isDarkTheme
                                          ? greyTextStyle.copyWith(
                                              fontWeight: semiBold)
                                          : textTextStyle.copyWith(
                                              fontWeight: semiBold),
                                      provider.isDarkTheme
                                          ? greyColor
                                          : textColor,
                                    )
                                  : SizedBox(),
                              location(
                                provider.isDarkTheme
                                    ? greyTextStyle.copyWith(
                                        fontWeight: semiBold)
                                    : textTextStyle.copyWith(
                                        fontWeight: semiBold),
                                provider.isDarkTheme ? greyColor : textColor,
                              ),
                              insertImage(context),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: () async {
                                  if (canMockLocation) {
                                    _isLoading = true;
                                    customDialog(
                                      context,
                                      'Peringatan!!!',
                                      'Matikan fake location.',
                                    );
                                    _isLoading = false;
                                  } else if (statusKerja == 0) {
                                    _isLoading = true;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Mohon isi status kerja',
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.amber,
                                      ),
                                    );
                                    _isLoading = false;
                                  } else if (jenisAbsen == 0) {
                                    _isLoading = true;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Mohon isi jenis absen',
                                          textAlign: TextAlign.center,
                                        ),
                                        backgroundColor: Colors.amber,
                                      ),
                                    );
                                    _isLoading = false;
                                  } else {
                                    _isLoading = true;
                                    _formKey.currentState!.save();

                                    nipas = snapshot.data!.data!.nipas;
                                    divisi = snapshot.data!.data!.divisi;
                                    username = snapshot.data!.data!.username;
                                    divisiid = snapshot.data!.data!.divisiid;
                                    var docName =
                                        _picture == null ? '' : _picture!.name;
                                    var docSize = _picture == null
                                        ? 0
                                        : await _picture!.length();
                                    DateFormat dateFormat =
                                        DateFormat("yyyy-MM-dd HH:mm:ss");

                                    AbsenModel absen = AbsenModel(
                                      absNipas: nipas,
                                      absDivisi: divisi,
                                      absStatus: statusKerja,
                                      absAlasan: alasanWFH,
                                      absTransportasi: keKantorMenggunakan,
                                      absKondisi: kondisiKesehatan,
                                      absJenis: jenisAbsen,
                                      absLatitude: latitude,
                                      absLongitude: longitude,
                                      absDocName: docName,
                                      absDocSize: docSize,
                                      absUsrnam: username,
                                      absUsrdat:
                                          dateFormat.format(DateTime.now()),
                                      absSuhu: '',
                                      absAddress: currentAddress,
                                      absOther: '',
                                      divisiid: divisiid,
                                      absZona: '',
                                      absDateAbsen:
                                          dateFormat.format(DateTime.now()),
                                      absKegiatan: '',
                                    );

                                    _apiService!.saveWithImage(
                                      absen,
                                      SignInPage.accessToken!,
                                      imageFile,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'terimakasih  telah melakukan absen',
                                        ),
                                        backgroundColor: greenColor,
                                      ),
                                    );
                                    _isLoading = false;
                                    Navigator.pushNamed(context, '/home');
                                  }
                                },
                                child: _isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: whiteColor,
                                        ),
                                      )
                                    : Text(
                                        'submit',
                                        style: whiteTextStyle.copyWith(
                                            fontSize: 16),
                                      ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    showError();
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: provider.isDarkTheme ? whiteColor : textColor,
                  ),
                );
              },
            ));
      },
    );
  }

  showError() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Timer(Duration(seconds: 3), () {
            logout();
            Navigator.pushNamed(context, '/blank');
          });
          return AlertDialog(
            title: Text("Peringatan"),
            content: Text("Mohon maaf user anda tidak terdaftar!"),
          );
        });
  }

  Row insertImage(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 135,
          color: Colors.grey[200],
          margin: EdgeInsets.only(top: 10, bottom: 20),
          child: _decideImageView(),
        ),
        SizedBox(
          width: 10,
        ),
        ElevatedButton(
          onPressed: () {
            _openCamera(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[400],
          ),
          child: Text(
            'Select image',
            style: blackTextStyle.copyWith(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Column location(TextStyle styleHead, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latitude',
                  style: styleHead,
                ),
                Container(
                  width: 140,
                  child: Text('$latitude'),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: color,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                width: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Longitude',
                  style: styleHead,
                ),
                Container(
                  width: 140,
                  child: Text('$longitude'),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: color,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Alamat',
          style: styleHead,
        ),
        Container(
          width: double.infinity,
          child: Text(
              currentAddress == 'Kecamatan Kramat jati, 13630, Indonesia'
                  ? 'Gedung Asabri Pusat'
                  : currentAddress),
          padding: EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: color,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          height: 150,
          child: googleMaps(),
        ),
        SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.grey[400],
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () {
            _determinePosition();
          },
          child: Text(
            'Perbahrui Lokasi',
            style: blackTextStyle,
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Column radioListJenisAbsen(
      TextStyle style, TextStyle styleHead, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis absen?',
          style: styleHead,
        ),
        new RadioListTile(
          value: 1,
          title: new Text(
            "Masuk",
            style: style,
          ),
          groupValue: jenisAbsen,
          onChanged: (int? value) {
            _jenisAbsen(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 2,
          title: new Text(
            "Pulang",
            style: style,
          ),
          groupValue: jenisAbsen,
          onChanged: (int? value) {
            _jenisAbsen(value!);
          },
          activeColor: color,
        ),
      ],
    );
  }

  Column radioListKondisiKesehatan(
      TextStyle style, TextStyle styleHead, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bagainama kondisi kesehatan anda saat ini?',
          style: styleHead,
        ),
        new RadioListTile(
          value: 1,
          title: new Text(
            "Sehat",
            style: style,
          ),
          groupValue: kondisiKesehatan,
          onChanged: (int? value) {
            _kondisiKesehatan(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 2,
          title: new Text(
            "Demam",
            style: style,
          ),
          groupValue: kondisiKesehatan,
          onChanged: (int? value) {
            _kondisiKesehatan(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 3,
          title: new Text(
            "Other",
            style: style,
          ),
          groupValue: kondisiKesehatan,
          onChanged: (int? value) {
            _kondisiKesehatan(value!);
          },
          activeColor: color,
        ),
      ],
    );
  }

  Column radioListKeKantor(TextStyle style, TextStyle styleHead, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apakah anda menggunakan transportasi umum/publik jika pergi bekerja ke kantor?',
          style: styleHead,
        ),
        new RadioListTile(
          value: 1,
          title: new Text(
            "Ya",
            style: style,
          ),
          groupValue: keKantorMenggunakan,
          onChanged: (int? value) {
            _keKantorMenggunakan(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 2,
          title: new Text(
            "Tidak",
            style: style,
          ),
          groupValue: keKantorMenggunakan,
          onChanged: (int? value) {
            _keKantorMenggunakan(value!);
          },
          activeColor: color,
        ),
      ],
    );
  }

  Column radioListWFH(TextStyle style, TextStyle styleHead, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alasan mengerjakan kerja dari rumah',
          style: styleHead,
        ),
        new RadioListTile(
          value: 1,
          title: new Text(
            "Usia > 50 tahun dan menggunakan transfortasi umum/publik",
            style: style,
          ),
          groupValue: alasanWFH,
          onChanged: (int? value) {
            _alasanWFH(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 2,
          title: new Text(
            "Hamil",
            style: style,
          ),
          groupValue: alasanWFH,
          onChanged: (int? value) {
            _alasanWFH(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 3,
          title: new Text(
            "Mengalami gejala covid-19",
            style: style,
          ),
          groupValue: alasanWFH,
          onChanged: (int? value) {
            _alasanWFH(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 4,
          title: new Text(
            "Sesuai jadwal kerja untuk melaksanakan kerja dari rumah (WFH)",
            style: style,
          ),
          groupValue: alasanWFH,
          onChanged: (int? value) {
            _alasanWFH(value!);
          },
          activeColor: color,
        ),
      ],
    );
  }

  Column radioListSK(TextStyle style, TextStyle styleHead, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status saat ini',
          style: styleHead,
        ),
        new RadioListTile(
          value: 1,
          title: new Text(
            "Kerja dari rumah (WFH)",
            style: style,
          ),
          groupValue: statusKerja,
          onChanged: (int? value) {
            _statusKerja(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 2,
          title: new Text(
            "Kerja dari kantor (WFO)",
            style: style,
          ),
          groupValue: statusKerja,
          onChanged: (int? value) {
            _statusKerja(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 3,
          title: new Text(
            "Tidak kerja karena sakit bukan covid-19",
            style: style,
          ),
          groupValue: statusKerja,
          onChanged: (int? value) {
            _statusKerja(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 4,
          title: new Text(
            "Tidak kerja karena sakit positif covid-19",
            style: style,
          ),
          groupValue: statusKerja,
          onChanged: (int? value) {
            _statusKerja(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 5,
          title: new Text(
            "Tidak kerja karena izin",
            style: style,
          ),
          groupValue: statusKerja,
          onChanged: (int? value) {
            _statusKerja(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 6,
          title: new Text(
            "Tidak kerja karena cuti",
            style: style,
          ),
          groupValue: statusKerja,
          onChanged: (int? value) {
            _statusKerja(value!);
          },
          activeColor: color,
        ),
        new RadioListTile(
          value: 7,
          title: new Text(
            "Absensi hari libur",
            style: style,
          ),
          groupValue: statusKerja,
          onChanged: (int? value) {
            _statusKerja(value!);
          },
          activeColor: color,
        ),
      ],
    );
  }

  Column costumTextForm(String name, String nipas, String divisi) {
    return Column(
      children: [
        SizedBox(height: 30),
        TextFormField(
          enabled: false,
          initialValue: name,
          decoration: InputDecoration(
            labelText: 'Karyawan Asabri',
            border: OutlineInputBorder(),
          ),
          maxLength: 30,
        ),
        TextFormField(
          enabled: false,
          initialValue: nipas,
          decoration: InputDecoration(
            labelText: 'NIPAS',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: textColor,
                width: 2.0,
              ),
            ),
          ),
          maxLength: 30,
        ),
        TextFormField(
          enabled: false,
          initialValue: divisi,
          decoration: InputDecoration(
            labelText: 'Divisi',
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: textColor,
              width: 2.0,
            )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
