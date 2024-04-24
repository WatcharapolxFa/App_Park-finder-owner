import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

// สมมติว่าคุณมีคลาสสำหรับส่งค่ากลับเมื่อมีการแก้ไข
class EditablePriceButton extends StatefulWidget {
  final double initialPrice;
  final Function(double) onPriceChanged;

  const EditablePriceButton({
    super.key,
    required this.initialPrice,
    required this.onPriceChanged,
  });

  @override
  State<EditablePriceButton> createState() => _EditablePriceButtonState();
}

class _EditablePriceButtonState extends State<EditablePriceButton> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialPrice.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('แก้ไขราคาที่จอดรถ'),
        content: TextField(
          controller: _controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(hintText: 'ใส่ราคาที่คุณต้องการ'),
        ),
        actions: [
          TextButton(
            child: const Text('ยกเลิก'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('บันทึก'),
            onPressed: () {
              final newPrice = double.tryParse(_controller.text);
              if (newPrice != null) {
                widget.onPriceChanged(newPrice);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showEditDialog,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColor.backgroundButtonAddPictureColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: RichText(
          textAlign: TextAlign.center, // ให้ข้อความอยู่ตรงกลาง
          text: TextSpan(
            children: [
              TextSpan(
                text: '${_controller.text} ', // ตัวเลขราคา
                style: const TextStyle(
                  color: AppColor.appPrimaryColor, // สีของตัวเลขราคา
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  // ขนาดของตัวเลขราคา
                ),
              ),
              const TextSpan(
                text: '\nบาท / ชั่วโมง', // ข้อความ "บาท/ชั่วโมง"
                style: TextStyle(
                  color: Colors.grey, // สีของข้อความ "บาท/ชั่วโมง"
                  fontSize: 14, // ขนาดของข้อความ "บาท/ชั่วโมง"
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
