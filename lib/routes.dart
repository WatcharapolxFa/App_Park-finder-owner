import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/screens/history/history.dart';
import 'package:parking_finder_app_provider/screens/notification/notification_list.dart';
import 'package:parking_finder_app_provider/screens/parking-manage/my_parking.dart';
import 'package:parking_finder_app_provider/screens/welcome/welcome_first_screen.dart';
import 'package:parking_finder_app_provider/screens/welcome/welcome_second_screen.dart';
import 'package:parking_finder_app_provider/screens/welcome/welcome_third_screen.dart';
import 'package:parking_finder_app_provider/screens/login/login.dart';
import 'package:parking_finder_app_provider/screens/register/register_user.dart';
import 'package:parking_finder_app_provider/screens/resetpassword/resetpassword.dart';
import 'package:parking_finder_app_provider/screens/register-parking/parking_detail.dart';
import 'package:parking_finder_app_provider/screens/logged-in/index.dart';
import 'package:parking_finder_app_provider/screens/income/income.dart';
import 'package:parking_finder_app_provider/screens/home/home.dart';

class RouteConfig {
  static Map<String, WidgetBuilder> routes = {
    '/welcome': (context) => const WelcomeFirstScreen(),
    '/welcome1': (context) => const WelcomeSecondScreen(),
    '/welcome2': (context) => const WelcomeThirdScreen(),
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterUserScreen(),
    '/reset_password': (context) => const ResetPasswordScreen(),
    '/parking_detail_register': (context) => const ParkingDetailScreen(),
    '/logged_in': (context) => const LoggedInPage(screenIndex: 0),
    '/income': (context) => const IncomeScreen(),
    '/home': (context) => const HomeScreen(),
    '/history': (context) => const HistoryScreen(),
    '/notification': (context) => const NotificationListScreen(),
    '/my_parking': (context) => const MyParkingScreen(),
  };
}
