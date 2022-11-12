import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luva/src/screens/device_list_view.dart';
import 'package:luva/src/screens/qr_code_scanner_view.dart';
import 'package:luva/src/screens/translation_screen.dart';
import 'package:luva/src/screens/home.dart';
import 'home.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  var platform = MethodChannel("com.example.luva/BleException");
  platform.invokeMethod("setBleErrorHandler");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DeviceList() //TranslationScreen()
    );
  }
}


