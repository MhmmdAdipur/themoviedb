import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:themoviedb/controllers/controllers.dart';
import 'package:themoviedb/shared/shared.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final movieController = Get.put(MovieController(), permanent: true);
  late StreamSubscription streamConnectivity;

  @override
  void initState() {
    super.initState();
    streamConnectivity = Connectivity().onConnectivityChanged.listen((status) {
      if (status == ConnectivityResult.none) {
        SharedMethod.getSnackBar(
          title: 'Koneksi Internet Terputus',
          message: 'Mohon periksa ulang koneksi internet anda.',
          icon: EvaIcons.wifiOffOutline,
          isError: true,
          duration: null,
        );
      } else {
        Get.closeCurrentSnackbar();
      }
    });
    initialization();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initialization() async {
    await Future.delayed(const Duration(milliseconds: 500));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: SharedValue.whiteColor,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: .5),
        ),
      ),
      defaultTransition: Transition.rightToLeft,
      getPages: SharedValue.pages,
      initialRoute: RouteName.home,
    );
  }
}
