import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'pages/home_page.dart';
import 'providers/ideias_provider.dart';
import 'services/ideias_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BatalhaDeIdeiasApp());
}

class BatalhaDeIdeiasApp extends StatelessWidget {
  const BatalhaDeIdeiasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IdeiasService>(
          create: (_) => IdeiasService(),
        ),
        ChangeNotifierProvider<IdeiasProvider>(
          create: (context) => IdeiasProvider(
            context.read<IdeiasService>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Batalha de Ideias',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
