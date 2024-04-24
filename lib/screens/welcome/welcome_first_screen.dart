import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';

class WelcomeFirstScreen extends StatelessWidget {
  const WelcomeFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    'ยินดีต้อนรับสู่',
                    style: TextStyle(
                      color: Color(0xFF5E5E5E),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SvgPicture.asset(
                    'lib/assets/images/logo_parkfinder.svg',
                    width: 200,
                    height: 40,
                  ),
                  const SizedBox(height: 80),
                  Image.asset(
                    'lib/assets/images/welcome01.png',
                    width: 350,
                    height: 300,
                  ),
                  const SizedBox(height: 100),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'มาเริ่มต้นสัมผัสประสบการณ์สร้างรายได้ง่าย ๆ ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'จากพื้นที่จอดรถที่คุณมี! ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlueButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/welcome1');
                    },
                    label: 'ถัดไป',
                  ),
                  
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
