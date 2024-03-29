import 'package:codepandas/Pages/discover.dart';
import 'package:codepandas/Pages/groups.dart';
import 'package:codepandas/Pages/settings.dart';
import 'package:codepandas/Pages/upload.dart';
import 'package:codepandas/Services/provider.dart';
import 'package:codepandas/firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (_) => ProviderService(),
      child: MaterialApp(
        title: 'StorageBox',
        theme: ThemeData(
          primaryColor: const Color(0xffF64747),
          cardColor: const Color(0xffE2E2E2),
          canvasColor: const Color(0xffF64747),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const App(),
          '/home': (context) => const HomePage(),
          '/upload': (context) => const UploadScreen(),
          '/discover': (context) => const Discover(),
          '/groups': (context) => const Groups(),
          '/settings': (context) => const Settings(),
        },
      ),
    );
  }
}
