import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/screens/account/account.dart';
import 'package:parking_finder_app_provider/screens/chat/chat_list.dart';
import 'package:parking_finder_app_provider/screens/home/home.dart';
import 'package:parking_finder_app_provider/screens/income/income.dart';
import 'package:parking_finder_app_provider/screens/notification/notification_list.dart';
import 'package:parking_finder_app_provider/widgets/navbar_.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key, required this.screenIndex});
  final int screenIndex;

  @override
  LoggedInState createState() => LoggedInState();
}

class LoggedInState extends State<LoggedInPage> {
  
  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // ignore: unrelated_type_equality_checks
    _selectedIndex = widget.screenIndex != Null ? widget.screenIndex : 0;
  }

  

  final _pages = [
   const  HomeScreen(),
    const ChatListScreen(),
    const IncomeScreen(),
    const NotificationListScreen(),
    const AccountScreen(),
  ];

  Color defaultColor = Colors.black87;
  Color activeColor = const Color(0xFF6828DC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomNavBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }
}
