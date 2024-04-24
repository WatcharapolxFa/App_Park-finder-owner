import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:parking_finder_app_provider/widgets/text_filed_icon.dart';
import 'package:parking_finder_app_provider/screens/register/verify_email.dart';

import '../../assets/colors/constant.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});
  @override
  RegisterUserScreenState createState() => RegisterUserScreenState();
}

class RegisterUserScreenState extends State<RegisterUserScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final logger = Logger();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<String?> registerProvider(Map<String, dynamic> data) async {
    final url = Uri.parse('${dotenv.env['HOST']}/provider/register');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return response.body; // สำเร็จ คืนข้อมูลจาก response
      } else {
        return null; // ไม่สำเร็จ
      }
    } catch (error) {
      logger.i('Error connecting to API: $error');
      return null;
    }
  }

  Future<void> _handleRegistration() async {
    final data = {
      'first_name': firstNameController.text,
      'last_name': lastNameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'password': passwordController.text,
    };

    final result = await registerProvider(data);

    if (result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VerifyEmailScreen(email: emailController.text),
          ),
        );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(
              content: Text('การลงทะเบียนไม่สำเร็จ, โปรดลองใหม่อีกครั้ง.')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),

                      // Logo
                      SvgPicture.asset(
                        'lib/assets/images/logo_parkfinder.svg',
                        width: 50,
                        height: 50,
                      ),

                      const SizedBox(height: 40),

                      // Text "ลงทะเบียน"
                      const Text(
                        'ลงทะเบียน',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 60),

                      TextFiledIcon(
                        controller: firstNameController,
                        label: 'ชื่อ',
                        iconData: Icons.person,
                      ),

                      const SizedBox(height: 20),

                      TextFiledIcon(
                        controller: lastNameController,
                        label: 'นามสกุล',
                        iconData: Icons.person_outline,
                      ),

                      const SizedBox(height: 20),

                      TextFiledIcon(
                        controller: phoneController,
                        label: 'เบอร์โทรศัพท์มือถือ',
                        iconData: Icons.phone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Only allow numbers
                          LengthLimitingTextInputFormatter(
                              10), // Limit to 10 characters
                        ],
                      ),

                      const SizedBox(height: 20),

                      TextFiledIcon(
                        controller: emailController,
                        label: 'อีเมล',
                        iconData: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      TextFiledIcon(
                        controller: passwordController,
                        label: 'รหัสผ่าน',
                        iconData: Icons.lock,
                        obscureText: true,
                      ),

                      const SizedBox(height: 20),

                      TextFiledIcon(
                        controller: confirmPasswordController,
                        label: 'ยืนยันรหัสผ่าน',
                        iconData: Icons.lock_outline,
                        obscureText: true,
                      ),

                      const SizedBox(height: 40),

                      BlueButton(
                        label: 'ลงทะเบียน',
                        onPressed: _handleRegistration,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'เป็นสมาชิกอยู่แล้ว?',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                color: AppColor.appPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
