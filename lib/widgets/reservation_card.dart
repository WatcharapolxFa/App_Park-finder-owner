import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';
import 'package:parking_finder_app_provider/models/history_model.dart';

class ReservationCard extends StatelessWidget {
  final History reservation;
  final bool showPrice; // เพิ่มการตั้งค่าเพื่อความยืดหยุ่นในการแสดงราคา
  final bool showStatus; // ตัวเลือกในการแสดงหรือซ่อนสถานะ
  final Color? customColor; // สามารถปรับสีของ card ได้

  const ReservationCard(
      {super.key,
      required this.reservation,
      this.showPrice = true, // ตั้งค่าเริ่มต้นให้แสดงราคา
      this.showStatus = true, // ตั้งค่าเริ่มต้นให้แสดงสถานะ
      this.customColor // ไม่มีค่าเริ่มต้น เพื่อให้สามารถกำหนดได้ตามต้องการ
      });
  Widget historyStatusToText(String status) {
    String text;
    Color color;
    switch (status) {
      case "Cancel":
        text = "การจองถูกยกเลิก";
        color = AppColor.appStatusRed;
        break;
      case "Successful":
        text = "ทำการจอดเรียบร้อย";
        color = AppColor.appStatusGreen;
        break;
      case "Pending":
        text = "รอการชำระเงิน";
        color = AppColor.appYellow;
        break;
      case "Pending Approval":
        text = "รอการชำระเงิน";
        color = AppColor.appYellow;
        break;
      case "Pending Approval Process":
        text = "รอการอนุมัติ";
        color = AppColor.appStatusRed;
        break;
      case "Process":
        text = "รอการดำเนินการ";
        color = AppColor.appPrimaryColor;
        break;
      case "Parking":
        text = "กำลังจอด";
        color = AppColor.appStatusGreen;
        break;

      default:
        text = "รอการดำเนินการ";
        color = AppColor.appPrimaryColor;
    }

    return Text(
      text,
      style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  String convertToTwoDigitFormat(String input) {
    return input.length == 1 ? "0$input" : input;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColor.appPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(reservation.dateStart),
                        if (reservation.dateStart != reservation.dateEnd)
                          const Text(" - "),
                        if (reservation.dateStart != reservation.dateEnd)
                          Text(reservation.dateEnd),
                        const SizedBox(width: 10),
                        Text(convertToTwoDigitFormat(
                            (reservation.hourStart).toString())),
                        const Text(":"),
                        Text(convertToTwoDigitFormat(
                            (reservation.minStart).toString())),
                        const Text(" - "),
                        Text(convertToTwoDigitFormat(
                            (reservation.hourEnd).toString())),
                        const Text(":"),
                        Text(convertToTwoDigitFormat(
                            (reservation.minEnd).toString())),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "ที่จอดรถคุณ${reservation.parkingName}",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reservation.address,
                            style: const TextStyle(fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    historyStatusToText(reservation.status)
                  ],
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                  ),
                ],
              )
            ],
          ),
          const Divider(thickness: 1)
        ],
      ),
    );
  }
}
