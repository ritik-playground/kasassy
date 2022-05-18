// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kasassy/bootstrap.dart';
import 'package:kasassy/data/repositories/authentication_repository.dart';
import 'package:kasassy/data/repositories/database_repository.dart';
import 'package:kasassy/data/repositories/device_repository.dart';
import 'package:kasassy/data/repositories/storage_repository.dart';
import 'package:kasassy/features/app/view/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await bootstrap(
    () => App(
      authenticationRepository: AuthenticationRepository(),
      databaseRepository: DatabaseRepository(),
      storageRepository: StorageRepository(),
      deviceRepository: DeviceRepository(),
    ),
  );
}
