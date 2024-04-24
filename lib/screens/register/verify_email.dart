import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';

import '../../assets/colors/constant.dart';
import '../login/login.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;

  // Constructor to get the email from the previous page
  const VerifyEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0), // เว้นขอบ 20 px
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColor.appPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                        15.0), // ค่านี้ควบคุมความกลมของมุม
                  ),
                  child: const Icon(
                    Icons.email,
                    color: AppColor.appPrimaryColor,
                    size: 100.0,
                  ),
                ),
                const SizedBox(height: 20),

                // ข้อความ "ยืนยันการลงทะเบียน"
                const Text(
                  'ยืนยันการลงทะเบียน',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // แสดงอีเมลที่รับมา
                Text(
                  'อีเมล: $email',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                // ข้อความ "กรุณาคลิกลิงก์ในอีเมลเพื่อยืนยันการลงทะเบียน"
                const Text(
                  'กรุณาคลิกลิงก์ในอีเมลเพื่อยืนยันการลงทะเบียน',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                // ปุ่มกลับหน้าเข้าสู่ระบบ
                BlueButton(
                  label: 'กลับหน้าเข้าสู่ระบบ',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
