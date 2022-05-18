import 'package:flutter/widgets.dart';
import 'package:kasassy/features/app/bloc/app_bloc.dart';
import 'package:kasassy/features/details/details_page.dart';
import 'package:kasassy/features/home/home_page.dart';
import 'package:kasassy/features/login/login_page.dart';
import 'package:kasassy/features/splash/splash_page.dart';

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
