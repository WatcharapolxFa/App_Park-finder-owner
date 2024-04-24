import 'package:flutter/material.dart';
import '../../assets/colors/constant.dart';

class UploadButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const UploadButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 91, // กำหนดความกว้าง
        height: 113, // กำหนดความสูง
        decoration: BoxDecoration(
          color: AppColor.backgroundButtonAddPictureColor, // สีพื้นหลังของปุ่ม
          borderRadius: BorderRadius.circular(15), // กำหนดรูปทรง
        ),
        padding: const EdgeInsets.all(17), // กำหนด padding
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded,
                size: 24, color: AppColor.backgroundAddCircle), // ไอคอนรูปบวก
            SizedBox(height: 13), // กำหนดช่องว่าง
            Text(
              "อัปโหลดเอกสาร",
              style: TextStyle(
                  color: Colors.black, fontSize: 12), // กำหนดสไตล์ข้อความ
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
