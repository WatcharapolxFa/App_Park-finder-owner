import 'package:flutter/material.dart';
import '../assets/colors/constant.dart';

class WhiteButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const WhiteButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 309, // กำหนดความกว้าง
      height: 54, // กำหนดความสูง
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          foregroundColor: MaterialStateProperty.all(AppColor.appPrimaryColor),
          side: MaterialStateProperty.all(const BorderSide(color: AppColor.appPrimaryColor)), // เพิ่มเส้นขอบสีฟ้า
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)), // ปรับ padding
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // ปรับเป็น borderRadius 10px
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColor.appPrimaryColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
