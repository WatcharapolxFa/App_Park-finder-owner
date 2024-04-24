import 'package:flutter/material.dart';
import '../assets/colors/constant.dart';

class BlueButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color color; 

  // ทำให้พารามิเตอร์สีเป็น optional และกำหนดค่า default หากไม่ได้รับค่าใดๆ
  const BlueButton({super.key, required this.label, required this.onPressed, this.color = AppColor.appPrimaryColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 309, // กำหนดความกว้าง
      height: 54, // กำหนดความสูง
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color), // ใช้พารามิเตอร์สีที่รับเข้ามา
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)), // ปรับ padding เพื่อให้เข้ากับความสูงใหม่
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // ปรับเป็น borderRadius 10px
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
