import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:parking_finder_app_provider/widgets/text_filed_icon.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../assets/colors/constant.dart';

class NewPasswordScreen extends StatefulWidget {
  final String email;
  const NewPasswordScreen({super.key, required this.email});

  @override
  NewPasswordState createState() => NewPasswordState();
}

class NewPasswordState extends State<NewPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> updatePassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
      );
      return;
    }

    final response = await http.patch(
      Uri.parse('${dotenv.env['HOST']}/provider/new_password'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'email': widget.email,
        'password': passwordController.text,
      }),
    );
    if (!mounted) return;

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('รหัสผ่านได้ถูกเปลี่ยนแล้ว')),
      );
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/login');
      // Navigate back or to another screen if necessary
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('มีข้อผิดพลาดในการเปลี่ยนรหัสผ่าน')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เปลี่ยนรหัสผ่าน"),
        backgroundColor: AppColor.appPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: AppColor.appPrimaryColor.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(15.0), // ค่านี้ควบคุมความกลมของมุม
                ),
                child: const Icon(
                  Icons.lock_reset,
                  color: AppColor.appPrimaryColor,
                  size: 100.0,
                ),
              ),
              const SizedBox(height: 60),
              const Text(
                "เปลี่ยนรหัสผ่าน ?",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 27),
              const Text(
                "โปรดกรอกรหัสกรอกรหัสผ่านใหม่",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 68),
              // Icon, Text and TextFields as before
              TextFiledIcon(
                controller: passwordController,
                label: 'รหัสผ่านใหม่',
                iconData: Icons.lock,
                keyboardType: TextInputType.text,
                obscureText: true, // Hide password
              ),
              TextFiledIcon(
                controller: confirmPasswordController,
                label: 'ยืนยันรหัสผ่านใหม่',
                iconData: Icons.lock_outline,
                keyboardType: TextInputType.text,
                obscureText: true, // Hide password
              ),
              const SizedBox(height: 60),
              BlueButton(
                label: 'ยืนยัน',
                onPressed: updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
