// ARQUIVO-MODELO.
//
// Execute:
//   flutter pub get
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// O FlutterFire irá substituir este arquivo pelas configurações
// do seu projeto Firebase.

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Execute "flutterfire configure" para gerar este arquivo.',
    );
  }
}
