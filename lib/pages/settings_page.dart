import 'package:aplikasi_asabri_nullsafety/common/theme.dart';
import 'package:aplikasi_asabri_nullsafety/cubit/auth_cubit.dart';
import 'package:aplikasi_asabri_nullsafety/provider/preferences_provider.dart';
import 'package:aplikasi_asabri_nullsafety/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsTitle = 'Settings';

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          settingsTitle,
          style: whiteTextStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(settingsTitle),
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return ListView(
            children: [
              Material(
                child: Column(
                  children: [
                    BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is AuthFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(state.error),
                            ),
                          );
                        } else if (state is AuthInitial) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/sign-in', (route) => false);
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListTile(
                          title: Text('Keluar'),
                          trailing: IconButton(
                              onPressed: () {
                                context.read<AuthCubit>().signOut();
                              },
                              icon: Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              )),
                        );
                      },
                    ),
                    Consumer<PreferencesProvider>(
                      builder: (context, provider, child) {
                        return ListTile(
                          title: Text('Dark Theme'),
                          trailing: Switch.adaptive(
                            value: provider.isDarkTheme,
                            onChanged: (value) {
                              provider.enableDarkTheme(value);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
