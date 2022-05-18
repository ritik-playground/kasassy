// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kasassy/constants/styles.dart';
import 'package:kasassy/constants/themes.dart';
import 'package:kasassy/data/repositories/authentication_repository.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/data/repositories/device_repository.dart';
import 'package:kasassy/data/repositories/storage_repository.dart';
import 'package:kasassy/features/app/bloc/app_bloc.dart';
import 'package:kasassy/features/app/routes/routes.dart';
import 'package:kasassy/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.databaseRepository,
    required this.storageRepository,
    required this.deviceRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final DatabaseRepository databaseRepository;
  final StorageRepository storageRepository;
  final DeviceRepository deviceRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: databaseRepository),
        RepositoryProvider.value(value: storageRepository),
        RepositoryProvider.value(value: deviceRepository),
      ],
      child: BlocProvider<AppBloc>(
        create: (_) => AppBloc(
          authenticationRepository: authenticationRepository,
          userDataRepository: databaseRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({
    Key? key,
  }) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Styles.style);
    return MaterialApp(
      title: 'Kasassy',
      theme: Themes.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
