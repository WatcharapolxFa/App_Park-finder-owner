import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../assets/colors/constant.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:parking_finder_app_provider/widgets/text_filed_icon.dart';
import 'authentication.dart';
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();

  Future<bool> forgotPasswordWithAPI(String email) async {
    Map data = {'Email': email};
    String body = json.encode(data);
    final url = Uri.parse('${dotenv.env['HOST']}/provider/send_forgot_otp');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response.statusCode == 200;
  }

  bool? emailsMatch;

  Future<void> handleEmail() async {
    bool match = await forgotPasswordWithAPI(emailController.text);
    // เช็คว่า context ยังมีอยู่หรือไม่ก่อนทำการใช้งาน
    if (!mounted) return;

    if (match) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              AuthenticationScreen(email: emailController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('ไม่พบ อีเมล นี้ในระบบ กรุณาลองอีกครั้ง')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ลืมรหัสผ่าน "),
        backgroundColor: AppColor.appPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 57),
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
                "ลืมรหัสผ่าน ?",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 27),
              const Text(
                "โปรดป้อนอีเมลของคุณ,รหัส OTP จะถูก\nส่งไปในอีเมลของคุณ เพื่อเปลี่ยนรหัสผ่านใหม่",
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 68),
              TextFiledIcon(
                controller: emailController,
                label: 'อีเมล',
                iconData: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 166),
              BlueButton(
                label: 'ยืนยัน',
                onPressed: () {
                  handleEmail();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
