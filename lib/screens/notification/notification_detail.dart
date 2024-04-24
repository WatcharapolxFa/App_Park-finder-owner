import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parking_finder_app_provider/services/parking_area_service.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:parking_finder_app_provider/widgets/button_white.dart';

class NotificationDetailScreen extends StatefulWidget {
  const NotificationDetailScreen({
    super.key,
    required this.typeNotification,
    this.title,
    this.description,
    this.parkingName,
    this.startDate,
    this.endDate,
    this.entryTime,
    this.exitTime,
    this.price,
    this.callBackConfirm,
    this.callBackCancel,
  });
  final String typeNotification;
  final String? title;
  final String? description;
  final String? parkingName;
  final String? startDate;
  final String? endDate;
  final TimeOfDay? entryTime;
  final TimeOfDay? exitTime;
  final int? price;
  final String? callBackConfirm;
  final String? callBackCancel;
  @override
  NotificationDetailState createState() => NotificationDetailState();
}

class NotificationDetailState extends State<NotificationDetailScreen> {
  final parkingAreaService = ParkingAreaService();

  String convertTypeNotificationButton1() {
    if (widget.typeNotification == "approve") {
      return "ยืนยัน";
    }
    return "";
  }

  String convertTypeNotificationButton2() {
    if (widget.typeNotification == "approve") {
      return "ยกเลิก";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "การแจ้งเตือน",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColor.appPrimaryColor.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(90.0), // ค่านี้ควบคุมความกลมของมุม
              ),
              child: const Icon(
                Icons.timer_outlined,
                color: AppColor.appPrimaryColor,
                size: 100.0,
              ),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                Text(
                  widget.title!,
                  style: const TextStyle(
                      color: AppColor.appPrimaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.description!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(35),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'lib/assets/images/logo_parkfinder.svg',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.parkingName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('วันที่จอด'),
                        Text(widget.startDate!),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('วันที่ออก'),
                        Text(widget.endDate!),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('เวลาเข้าจอด'),
                        Text(
                            '${widget.entryTime!.hour.toString().padLeft(2, '0')}:${widget.entryTime!.minute.toString().padLeft(2, '0')} น.'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('เวลาออกจอด'),
                        Text(
                            '${widget.exitTime!.hour.toString().padLeft(2, '0')}:${widget.exitTime!.minute.toString().padLeft(2, '0')} น.'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ราคาที่ต้องจ่ายเพิ่ม'),
                        Text(
                          '${widget.price} บาท',
                          style: const TextStyle(color: AppColor.appGreenline),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BlueButton(
              label: convertTypeNotificationButton1(),
              onPressed: () async {
                EasyLoading.show();
                final response = await parkingAreaService
                    .approveReseveInAdvance(widget.callBackConfirm!);
                EasyLoading.dismiss();
                if (response) {
                  EasyLoading.showInfo("ยืนยันการจองสำเร็จ");
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/logged_in');
                } else {
                  EasyLoading.showError("ยืนยันไม่สำเร็จ");
                }
              },
            ),
            const SizedBox(height: 10),
            WhiteButton(
                label: convertTypeNotificationButton2(),
                onPressed: () async {
                  
                  EasyLoading.show();
                  final response = await parkingAreaService
                      .approveReseveInAdvance(widget.callBackCancel!);
                  EasyLoading.dismiss();
                  if (response) {
                    EasyLoading.showInfo("ยกเลิกการจองสำเร็จ");
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, '/logged_in');
                  } else {
                    EasyLoading.showError("ยกเลิกไม่สำเร็จ");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
