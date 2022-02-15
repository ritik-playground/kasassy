import 'package:flutter/widgets.dart';
import 'package:kasassy/app/bloc/app_bloc.dart';
import 'package:kasassy/details/details_page.dart';
import 'package:kasassy/home/home_page.dart';
import 'package:kasassy/login/login_page.dart';
import 'package:kasassy/splash/splash_page.dart';

List<Page> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.route()];
    case AppStatus.halfauthenticated:
      return [DetailsPage.route()];
    case AppStatus.splashscreen:
      return [SplashPage.route()];
  }
}
