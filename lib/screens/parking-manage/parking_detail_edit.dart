import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';
import 'package:parking_finder_app_provider/models/parking_spot.dart';
import 'package:parking_finder_app_provider/screens/parking-manage/my_parking.dart';
import 'package:parking_finder_app_provider/screens/review/review_list.dart';
import 'package:parking_finder_app_provider/services/parking_area_service.dart';
import 'package:parking_finder_app_provider/widgets/button_editable.dart';
import 'package:parking_finder_app_provider/widgets/select_week_days.dart';

class ParkingDetailEditScreen extends StatefulWidget {
  const ParkingDetailEditScreen({super.key, required this.parkingDetail});
  final ParkingSpot parkingDetail;
  @override
  ParkingDetailEditScreenState createState() => ParkingDetailEditScreenState();
}

class ParkingDetailEditScreenState extends State<ParkingDetailEditScreen> {
  final parkingAreaService = ParkingAreaService();
  double averageReview = 0.0;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  bool isSwitched = false;
  int selectedStars = 0;
  String selectedDate = "";
  final TextEditingController priceController =
      TextEditingController(text: "0"); // ตัวควบคุมสำหรับราคา

  List<bool> selectedDays = [];
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  List<String> filteredDays = [];
  @override
  void initState() {
    super.initState();
    averageReview = parkingAreaService
        .calculateAverageReviewScore(widget.parkingDetail.review);
    priceController.text = widget.parkingDetail.price.toString();
    selectedDays = List<bool>.filled(7, false);
  }

  Widget buildStar(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          selectedStars = index + 1;
        });
      },
      icon: Icon(
        Icons.star,
        color: (index < selectedStars) ? AppColor.appYellow : Colors.grey,
      ),
    );
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
    );
    if (pickedStartTime != null && pickedStartTime != selectedStartTime) {
      setState(() {
        selectedStartTime = pickedStartTime;
      });
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedEndTime = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? (selectedStartTime ?? TimeOfDay.now()),
    );
    if (pickedEndTime != null && pickedEndTime != selectedEndTime) {
      setState(() {
        selectedEndTime = pickedEndTime;
      });
      EasyLoading.show();
      final response =
          await parkingAreaService.updateParkingAreaDailyOpenStatus(
              widget.parkingDetail.parkingID,
              filteredDays,
              selectedStartTime!.hour,
              selectedEndTime!.hour);
      if (response) {
        EasyLoading.dismiss();
        EasyLoading.showInfo("แก้ไขสำเร็จ");
      } else {
        EasyLoading.dismiss();
        EasyLoading.showInfo("แก้ไขไม่สำเร็จ");
      }
    }
  }

  bool get isAnyDaySelected => selectedDays.any((isSelected) => isSelected);

  void editPrice() async {
    // ฟังก์ชันสำหรับการแก้ไขราคา
    final String? newPrice = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Price'),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter new price'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, priceController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (newPrice != null) {
      setState(() {
        priceController.text = newPrice;
      });
    }
  }

  void _updateSelectedDays(List<bool> newSelectedDays) {
    setState(() {
      selectedDays = newSelectedDays;
    });
    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        filteredDays.add(days[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyParkingScreen()));
            },
          ),
          title: Text(widget.parkingDetail.parkingName),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 430,
                      height: 150,
                      color: Colors.grey[200], // พื้นหลังช่องใส่รูป
                      child: PageView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Image.network(
                            (widget.parkingDetail.parkingPictureUrl),
                            key: ValueKey(Random().nextInt(100)),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ข้อความ
                    Text(
                      widget.parkingDetail.parkingName,
                      style: const TextStyle(fontSize: 24),
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ReviewList(
                                      reviews: widget.parkingDetail.review,
                                    )));
                      },
                      icon: const Icon(
                        Icons.star,
                        color: Colors.white, // สีขาว
                      ),
                      label: const Text(
                        'อ่านรีวิว',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColor.appPrimaryColor, // สีพื้นหลังของปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // กำหนดให้มุมเป็นสี่เหลี่ยม
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${widget.parkingDetail.address['address_text']} ${widget.parkingDetail.address['sub_district']} ${widget.parkingDetail.address['district']} ${widget.parkingDetail.address['province']} ${widget.parkingDetail.address['postal_code']}',
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: AppColor.appYellow), // ไอคอนรูปดาวสีเหลือง
                    const SizedBox(width: 5.0), // ระยะห่างระหว่างดาวกับตัวเลข
                    Text(averageReview.toString(),
                        style: const TextStyle(fontSize: 14.0)), // คะแนน
                    const SizedBox(
                        width: 20.0), // ระยะห่างระหว่างคะแนนกับข้อความ
                    Text('${widget.parkingDetail.review.length} รีวิว',
                        style: const TextStyle(fontSize: 14.0)), // จำนวนรีวิว
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(thickness: 2.0),
                Row(
                  children: [
                    const Text(
                      'สถานะที่จอดรถ : ',
                      style: TextStyle(
                          fontSize: 16), // กำหนดสไตล์ข้อความตามต้องการ
                    ),
                    Switch(
                      value: widget.parkingDetail.isOpen,
                      onChanged: (value) async {
                        int time = 0;
                        String status = "";
                        if (!widget.parkingDetail.isOpen) {
                          time = 0;
                          status = "open";
                        } else {
                          time = 1440;
                          status = "close";
                        }
                        final response = await parkingAreaService
                            .updateParkingAreaOpenStatus(
                                widget.parkingDetail.parkingID, time, status);
                        if (response) {
                          if (widget.parkingDetail.isOpen == false) {
                            EasyLoading.showSuccess("เปิดที่จอดรถเรียบร้อย");
                          } else {
                            EasyLoading.showSuccess("ปิดที่จอดรถเรียบร้อย");
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(
                              context, '/my_parking');
                        } else {
                          EasyLoading.showError("ไม่สามารถเปิดที่จอดรถ");
                        }
                      },
                      activeTrackColor: Colors.green, // สีของแทร็กเมื่อเปิด
                      activeColor: Colors.white, // สีของปุ่มสวิตช์เมื่อเปิด
                    ),
                  ],
                ),
                const Align(
                  alignment: Alignment.centerLeft, // จัดให้ข้อความชิดซ้าย
                  child: Text(
                    'วันที่เปิด-ปิด',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                SelectWeekDays(
                  selectedDays: selectedDays,
                  onSelectedDaysChanged: (List<bool> selectedDays) {
                    _updateSelectedDays(selectedDays);
                  },
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft, // จัดให้ข้อความชิดซ้าย
                  child: Text(
                    'เวลาที่เปิด-ปิด',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(
                                width: 1, color: AppColor.appPrimaryColor),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (!isAnyDaySelected) {
                            EasyLoading.showError(
                                "กรุณาเลือกวันที่ต้องการเปิด");
                          } else {
                            selectStartTime(context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.access_time,
                                size: 24.0, color: AppColor.appPrimaryColor),
                            Text(
                              selectedStartTime == null
                                  ? "เลือกเวลาเปิด"
                                  : selectedStartTime!.format(context),
                              style: const TextStyle(
                                  color: AppColor.appPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text('ถึง', style: TextStyle(color: Colors.black)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                            const BorderSide(
                                width: 1, color: AppColor.appPrimaryColor),
                          ),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (!isAnyDaySelected) {
                            EasyLoading.showError(
                                "กรุณาเลือกวันที่ต้องการเปิด");
                          } else if (selectedStartTime == null) {
                            EasyLoading.showError(
                                "กรุณาเลือกเวลาเปิดก่อนเวลาปิด");
                          } else {
                            selectEndTime(context);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.access_time,
                                size: 24.0, color: AppColor.appPrimaryColor),
                            Text(
                              selectedEndTime == null
                                  ? "เลือกเวลาปิด"
                                  : selectedEndTime!.format(context),
                              style: const TextStyle(
                                  color: AppColor.appPrimaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                EditablePriceButton(
                  initialPrice: double.tryParse(priceController.text) ??
                      30.00, // ใช้ค่าจาก priceController หรือค่าเริ่มต้นเป็น 75 หากแปลงไม่ได้
                  onPriceChanged: (newPrice) async {
                    setState(() {
                      priceController.text =
                          newPrice.toString(); // อัปเดตค่าใน priceController
                    });
                    final response =
                        await parkingAreaService.updateParkingAreaPrice(
                            widget.parkingDetail.parkingID,
                            double.parse(priceController.text).toInt());
                    if (response) {
                      EasyLoading.showSuccess("แก้ไขราคาสำเร็จ");
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, '/my_parking');
                    } else {
                      EasyLoading.showError("ไม่สามารถแก้ไขได้");
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
