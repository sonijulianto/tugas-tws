import 'dart:convert';
import 'dart:io';

import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/pages/sign_in_page.dart';
import 'package:aplikasi_asabri_nullsafety/provider/preferences_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RekapPage extends StatefulWidget {
  static const rekapTitle = 'Rekap';

  final Future<SharedPreferences>? sharedPreferences;
  RekapPage({this.sharedPreferences});

  @override
  _RekapPageState createState() => _RekapPageState();
}

class _RekapPageState extends State<RekapPage> {
  final String _baseUrl = 'https://dev-absensi.asabri.co.id/api';
  int _page = 0;
  int _limit = 10;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _posts = [];

  void _firstLoad(String token) async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res = await http.get(
          Uri.parse('$_baseUrl/user/getlistabsen/$_page/$_limit'),
          headers: {HttpHeaders.authorizationHeader: 'Bearer ' + token});

      setState(() {
        Map<String, dynamic> map = jsonDecode(res.body);
        _posts = map["data"];
      });
    } catch (err) {
      print('Something went wrong');
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore(String token) async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 11;
      _limit += 11; // Increase _page by 1
      try {
        final res = await http.get(
            Uri.parse('$_baseUrl/user/getlistabsen/$_page/$_limit'),
            headers: {HttpHeaders.authorizationHeader: 'Bearer ' + token});

        Map<String, dynamic> maap = jsonDecode(res.body);
        final List fetchedPosts = maap["data"];
        if (fetchedPosts.length > 0) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad(SignInPage.accessToken!);
    _controller = new ScrollController()
      ..addListener(() {
        _loadMore(SignInPage.accessToken!);
      });
  }

  @override
  void dispose() {
    _controller.removeListener(() => _loadMore(SignInPage.accessToken!));
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return Scaffold(
              body: _isFirstLoadRunning
                  ? Center(
                      child: CircularProgressIndicator(
                        color: provider.isDarkTheme ? whiteColor : textColor,
                      ),
                    )
                  : _posts.length != 0
                      ? Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _controller,
                                itemCount: _posts.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        right: 10,
                                        left: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                      color: provider.isDarkTheme
                                          ? Colors.grey[800]
                                          : whiteColor,
                                      border: Border.symmetric(
                                        horizontal: BorderSide(
                                            color: provider.isDarkTheme
                                                ? Colors.white38
                                                : Colors.black26),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Text(
                                                'Nama',
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                            Text(' : '),
                                            Expanded(
                                              child: Text(
                                                _posts[index]['absUsrnam'],
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Text(
                                                'Tanggal',
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                            Text(' : '),
                                            Expanded(
                                              child: Text(
                                                _posts[index]['absUsrdat'],
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Text(
                                                'Jam Absen',
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                            Text(' : '),
                                            Expanded(
                                              child: Text(
                                                _posts[index]['waktu'],
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Text(
                                                'Alamat',
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                            Text(' : '),
                                            Expanded(
                                              child: Text(
                                                _posts[index]['absAddress'],
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 100,
                                              child: Text(
                                                'Jenis Absen',
                                                style: provider.isDarkTheme
                                                    ? greyTextStyle
                                                    : blackTextStyle,
                                              ),
                                            ),
                                            Text(' : '),
                                            Expanded(
                                              child: Text(
                                                _posts[index]['jenisAbsen'],
                                                style: _posts[index]
                                                            ['jenisAbsen'] ==
                                                        'Masuk'
                                                    ? greenTextStyle
                                                    : redTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // when the _loadMore function is running
                            if (_isLoadMoreRunning == true)
                              Center(
                                child: LinearProgressIndicator(
                                  color: provider.isDarkTheme
                                      ? whiteColor
                                      : textColor,
                                ),
                              ),

                            // When nothing else to load
                            if (_hasNextPage == false)
                              Container(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                color: Colors.amber,
                                child: Center(
                                  child: Text(
                                      'You have fetched all of the content'),
                                ),
                              ),
                          ],
                        )
                      : Center(
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: -50,
                                  blurRadius: 30,
                                  offset: Offset(0, 10),
                                ),
                              ],
                              image: DecorationImage(
                                image: provider.isDarkTheme
                                    ? AssetImage('assets/data-not-found-2.png')
                                    : AssetImage('assets/data-not-found.png'),
                              ),
                            ),
                          ),
                        ));
        },
      ),
    );
  }
}
