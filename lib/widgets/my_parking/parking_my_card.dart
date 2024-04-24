import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';
import 'package:parking_finder_app_provider/models/parking_spot.dart';

class ParkingMyCard extends StatelessWidget {
  final ParkingSpot detail;
  final Color? customColor; // สามารถปรับสีของ card ได้

  const ParkingMyCard({
    super.key,
    required this.detail,
    this.customColor,
  });

  String parkingStatusToText(bool isOpen) {
    if (detail.statusApply == "accepted") {
      return isOpen ? "เปิด" : "ปิด";
    } else if (detail.statusApply == "wait for document") {
      return "รอส่งเอกสาร";
    } else if (detail.statusApply == "denied") {
      return "ไม่อนุมัติ";
    } else {
      return "รออนุมัติ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: customColor ?? Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                    Text(
                      detail.parkingName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${detail.address['address_text']} ${detail.address['sub_district']} ${detail.address['district']} ${detail.address['province']} ${detail.address['postal_code']}",
                      style: const TextStyle(fontSize: 15),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                parkingStatusToText(detail.isOpen),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: detail.isOpen
                      ? AppColor.appPrimaryColor
                      : Colors.red, // สามารถปรับเปลี่ยนตามต้องการ
                ),
              ),
            ],
          ),
          const Divider(thickness: 1),
        ],
      ),
    );
  }
}
