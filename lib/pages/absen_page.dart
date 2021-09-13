import 'dart:io';
import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/cubit/auth_cubit.dart';
import 'package:aplikasi_asabri_nullsafety/cubit/rekap_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class AbsenPage extends StatefulWidget {
  static const absenTitle = 'Absen';
  AbsenPage({Key? key}) : super(key: key);

  @override
  _AbsenPageState createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController nipasController = TextEditingController(text: '');
  TextEditingController divisiController = TextEditingController(text: '');
  TextEditingController statusKerjaController = TextEditingController(text: '');
  TextEditingController alasanWfhController = TextEditingController(text: '');
  TextEditingController keKantorMenggunakanController =
      TextEditingController(text: '');
  TextEditingController kondisiKesehatanController =
      TextEditingController(text: '');
  TextEditingController jenisAbsenController = TextEditingController(text: '');
  TextEditingController alamatController = TextEditingController(text: '');
  TextEditingController imageController = TextEditingController(text: '');

  File? imageFile;
  String statusKerja = "";
  String alasanWFH = "";
  String keKantorMenggunakan = "";
  String kondisiKesehatan = "";
  String jenisAbsen = "";
  double latitude = 0;
  double longitude = 0;
  String alamat = "";

  final Set<Marker> _marker = {};
  Position? currentposition;
  String currentAddress = 'My Address';
  LatLng? latLng;

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      } else {}
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      } else {}
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a Choice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Gallery'),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Camera'),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
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

  void _statusKerja(String value) {
    setState(() {
      statusKerja = value;
    });
  }

  void _alasanWFH(String value) {
    setState(() {
      alasanWFH = value;
    });
  }

  void _keKantorMenggunakan(String value) {
    setState(() {
      keKantorMenggunakan = value;
    });
  }

  void _kondisiKesehatan(String value) {
    setState(() {
      kondisiKesehatan = value;
    });
  }

  void _jenisAbsen(String value) {
    setState(() {
      jenisAbsen = value;
    });
  }

  @override
  void initState() {
    _marker.add(
      Marker(
        markerId: MarkerId("$latitude, $longitude"),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  String username = '';
  int nipas = 0;
  String divisi = '';

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return Container(
              margin: EdgeInsets.only(
                right: 30,
                left: 30,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      costumTextForm(
                        state.user.name,
                        state.user.nipas,
                        state.user.divisi,
                      ),
                      radioListSK(),
                      statusKerja == "Kerja dari rumah (WFH)"
                          ? radioListWFH()
                          : SizedBox(),
                      statusKerja != "" ? radioListKeKantor() : SizedBox(),
                      keKantorMenggunakan != ""
                          ? radioListKondisiKesehatan()
                          : SizedBox(),
                      kondisiKesehatan != ""
                          ? radioListJenisAbsen()
                          : SizedBox(),
                      location(),
                      insertImage(context),
                      Builder(
                        builder: (context) =>
                            BlocConsumer<RekapCubit, RekapState>(
                          listener: (context, state) {
                            if (state is RekapSuccess) {
                              // Navigator.pushNamed(context, '/home');
                            } else if (state is RekapFailed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(state.error),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is RekapLoading) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onPressed: () {
                                final isValid =
                                    formKey.currentState!.validate();

                                if (isValid) {
                                  final user = (context.read<AuthCubit>().state
                                          as AuthSuccess)
                                      .user;
                                  formKey.currentState!.save();
                                  context.read<RekapCubit>().rekapAbsen(
                                      name: username.isEmpty
                                          ? user.name
                                          : username,
                                      nipas: nipas == 0 ? user.nipas : nipas,
                                      divisi:
                                          divisi.isEmpty ? user.divisi : divisi,
                                      statusKerja: statusKerja,
                                      jenisAbsen: jenisAbsen,
                                      alamat: currentAddress ==
                                              'Kecamatan Kramat jati, 13630, Indonesia'
                                          ? 'Gedung Asabri Pusat'
                                          : currentAddress,
                                      alasanWfh: alasanWFH,
                                      keKantorMenggunakan: keKantorMenggunakan,
                                      kondisiKesehatan: kondisiKesehatan);

                                  final message =
                                      'Terimakasih $username telah melakukan absen';
                                  final snackBar = SnackBar(
                                    content: Text(message),
                                    backgroundColor: Colors.green,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: Text(
                                'submit',
                                style: whiteTextStyle.copyWith(fontSize: 16),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
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
            _showChoiceDialog(context);
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

  Column location() {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latitude',
                  style: textTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
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
                      color: textColor,
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
                  style: textTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
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
                      color: textColor,
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
          style: textTextStyle.copyWith(
            fontWeight: semiBold,
          ),
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
              color: textColor,
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
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-6.2568037, 106.8695489),
              zoom: 14.0,
            ),
            markers: _marker,
            onTap: (position) {
              setState(() {
                _marker.add(
                  Marker(
                    markerId:
                        MarkerId("${position.latitude}, ${position.longitude}"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: position,
                  ),
                );
              });
            },
          ),
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
          child: currentAddress == "My Address"
              ? Text(
                  'Pindai Lokasi',
                  style: blackTextStyle,
                )
              : Text(
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

  Column radioListJenisAbsen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis absen?',
          style: textTextStyle.copyWith(fontWeight: bold),
        ),
        new RadioListTile(
          value: "Masuk",
          title: new Text(
            "Masuk",
            style: textTextStyle,
          ),
          groupValue: jenisAbsen,
          onChanged: (String? value) {
            _jenisAbsen(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Pulang",
          title: new Text(
            "Pulang",
            style: textTextStyle,
          ),
          groupValue: jenisAbsen,
          onChanged: (String? value) {
            _jenisAbsen(value!);
          },
          activeColor: textColor,
        ),
      ],
    );
  }

  Column radioListKondisiKesehatan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bagainama kondisi kesehatan anda saat ini?',
          style: textTextStyle.copyWith(fontWeight: bold),
        ),
        new RadioListTile(
          value: "Sehat",
          title: new Text(
            "Sehat",
            style: textTextStyle,
          ),
          groupValue: kondisiKesehatan,
          onChanged: (String? value) {
            _kondisiKesehatan(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Demam",
          title: new Text(
            "Demam",
            style: textTextStyle,
          ),
          groupValue: kondisiKesehatan,
          onChanged: (String? value) {
            _kondisiKesehatan(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Other",
          title: new Text(
            "Other",
            style: textTextStyle,
          ),
          groupValue: kondisiKesehatan,
          onChanged: (String? value) {
            _kondisiKesehatan(value!);
          },
          activeColor: textColor,
        ),
      ],
    );
  }

  Column radioListKeKantor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Apakah anda menggunakan transportasi umum/publik jika pergi bekerja ke kantor?',
          style: textTextStyle.copyWith(fontWeight: bold),
        ),
        new RadioListTile(
          value: "Ya",
          title: new Text(
            "Ya",
            style: textTextStyle,
          ),
          groupValue: keKantorMenggunakan,
          onChanged: (String? value) {
            _keKantorMenggunakan(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Tidak",
          title: new Text(
            "Tidak",
            style: textTextStyle,
          ),
          groupValue: keKantorMenggunakan,
          onChanged: (String? value) {
            _keKantorMenggunakan(value!);
          },
          activeColor: textColor,
        ),
      ],
    );
  }

  Column radioListWFH() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alasan mengerjakan kerja dari rumah',
          style: textTextStyle.copyWith(fontWeight: bold),
        ),
        new RadioListTile(
          value: "Usia > 50 tahun dan menggunakan transfortasi umum/publik",
          title: new Text(
            "Usia > 50 tahun dan menggunakan transfortasi umum/publik",
            style: textTextStyle,
          ),
          groupValue: alasanWFH,
          onChanged: (String? value) {
            _alasanWFH(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Hamil",
          title: new Text(
            "Hamil",
            style: textTextStyle,
          ),
          groupValue: alasanWFH,
          onChanged: (String? value) {
            _alasanWFH(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Mengalami gejala covid-19",
          title: new Text(
            "Mengalami gejala covid-19",
            style: textTextStyle,
          ),
          groupValue: alasanWFH,
          onChanged: (String? value) {
            _alasanWFH(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value:
              "Sesuai jadwal kerja untuk melaksanakan kerja dari rumah (WFH)",
          title: new Text(
            "Sesuai jadwal kerja untuk melaksanakan kerja dari rumah (WFH)",
            style: textTextStyle,
          ),
          groupValue: alasanWFH,
          onChanged: (String? value) {
            _alasanWFH(value!);
          },
          activeColor: textColor,
        ),
      ],
    );
  }

  Column radioListSK() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status saat ini',
          style: textTextStyle.copyWith(fontWeight: bold),
        ),
        new RadioListTile(
          value: "Kerja dari rumah (WFH)",
          title: new Text(
            "Kerja dari rumah (WFH)",
            style: textTextStyle,
          ),
          groupValue: statusKerja,
          onChanged: (String? value) {
            _statusKerja(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Kerja dari kantor (WFO)",
          title: new Text(
            "Kerja dari kantor (WFO)",
            style: textTextStyle,
          ),
          groupValue: statusKerja,
          onChanged: (String? value) {
            _statusKerja(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Tidak kerja karena sakit bukan covid-19",
          title: new Text(
            "Tidak kerja karena sakit bukan covid-19",
            style: textTextStyle,
          ),
          groupValue: statusKerja,
          onChanged: (String? value) {
            _statusKerja(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Tidak kerja karena sakit positif covid-19",
          title: new Text(
            "Tidak kerja karena sakit positif covid-19",
            style: textTextStyle,
          ),
          groupValue: statusKerja,
          onChanged: (String? value) {
            _statusKerja(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Tidak kerja karena izin",
          title: new Text(
            "Tidak kerja karena izin",
            style: textTextStyle,
          ),
          groupValue: statusKerja,
          onChanged: (String? value) {
            _statusKerja(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Tidak kerja karena cuti",
          title: new Text(
            "Tidak kerja karena cuti",
            style: textTextStyle,
          ),
          groupValue: statusKerja,
          onChanged: (String? value) {
            _statusKerja(value!);
          },
          activeColor: textColor,
        ),
        new RadioListTile(
          value: "Absensi hari libur",
          title: new Text(
            "Absensi hari libur",
            style: textTextStyle,
          ),
          groupValue: statusKerja,
          onChanged: (String? value) {
            _statusKerja(value!);
          },
          activeColor: textColor,
        ),
      ],
    );
  }

  Column costumTextForm(String name, int nipas, String divisi) {
    return Column(
      children: [
        SizedBox(height: 30),
        TextFormField(
          // controller: nameController,
          enabled: false,
          initialValue: name,
          decoration: InputDecoration(
            labelText: 'Karyawan Asabri',
            border: OutlineInputBorder(),
          ),
          maxLength: 30,
          onSaved: (value) => setState(() => username = value!),
        ),
        TextFormField(
          // controller: nipasController,
          enabled: false,
          initialValue: nipas.toString(),
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
          onSaved: (value) => setState(() => nipas = int.parse(value!)),
        ),
        TextFormField(
          // controller: divisiController,
          enabled: false,
          initialValue: divisi,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Divisi',
            border: OutlineInputBorder(
                borderSide: BorderSide(
              color: textColor,
              width: 2.0,
            )),
          ),
          onSaved: (value) => setState(() => divisi = value!),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
