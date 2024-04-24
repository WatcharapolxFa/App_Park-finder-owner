import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parking_finder_app_provider/services/profile_service.dart';
import 'package:parking_finder_app_provider/theme.dart';
import 'package:parking_finder_app_provider/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/.env");
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  ProfileService profileService = ProfileService();
  var profile = await profileService.getProfile();

  runApp(MyApp(
    isUserLoggedIn: profile != null,
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.threeBounce
    ..loadingStyle = EasyLoadingStyle.custom
    ..maskType = EasyLoadingMaskType.black
    ..indicatorSize = 30.0
    ..radius = 15.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;
  final String? accessToken;

  const MyApp({super.key, required this.isUserLoggedIn, this.accessToken});

  @override
  Widget build(BuildContext context) {
    final initialRoute = isUserLoggedIn ? '/logged_in' : '/welcome';
    // final initialRoute = isUserLoggedIn ? '/notification_detail' : '/notification_detail';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: RouteConfig.routes,
      theme: AppTheme.lightTheme,
      builder: EasyLoading.init(),
    );
  }
}
