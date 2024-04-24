import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:parking_finder_app_provider/screens/register-parking/search_location.dart';
import 'package:parking_finder_app_provider/services/fetch_zip_info.dart';

import '../../assets/colors/constant.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:parking_finder_app_provider/widgets/custom_text_field.dart';

class ParkingDetailScreen extends StatefulWidget {
  const ParkingDetailScreen({super.key});

  @override
  ParkingDetailScreenState createState() => ParkingDetailScreenState();
}

class ParkingDetailScreenState extends State<ParkingDetailScreen> {
  final storage = const FlutterSecureStorage();
  final fetchZipInfoService = FetchZipInfoService();
  bool _isFormFilled = false;
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController alleyController = TextEditingController();
  final TextEditingController roadController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController subDistrictController = TextEditingController();
  final TextEditingController nearbyPlacesController = TextEditingController();
  final TextEditingController nameParkkingController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // ตั้งค่า listener สำหรับ TextEditingControllers
    _setupListeners();
  }

  @override
  void dispose() {
    houseNumberController.dispose();
    groupController.dispose();
    villageController.dispose();
    alleyController.dispose();
    roadController.dispose();
    postCodeController.dispose();
    provinceController.dispose();
    districtController.dispose();
    subDistrictController.dispose();
    nearbyPlacesController.dispose();
    nameParkkingController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  void _setupListeners() {
    final controllers = [
      houseNumberController,
      groupController,
      villageController,
      alleyController,
      roadController,
      postCodeController,
      provinceController,
      districtController,
      subDistrictController,
      nearbyPlacesController,
      nameParkkingController,
      latitudeController,
      longitudeController,
    ];

    for (var controller in controllers) {
      controller.addListener(_checkFormFilled);
    }
  }

  void _checkFormFilled() {
    final isFilled = houseNumberController.text.isNotEmpty &&
        groupController.text.isNotEmpty &&
        villageController.text.isNotEmpty &&
        alleyController.text.isNotEmpty &&
        roadController.text.isNotEmpty &&
        postCodeController.text.isNotEmpty &&
        provinceController.text.isNotEmpty &&
        districtController.text.isNotEmpty &&
        subDistrictController.text.isNotEmpty &&
        nearbyPlacesController.text.isNotEmpty &&
        nameParkkingController.text.isNotEmpty;
    setState(() {
      _isFormFilled = isFilled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลเพิ่มเติมของที่จอดรถ"),
        backgroundColor: AppColor.appPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: nameParkkingController,
              label: "ชื่อที่จอดรถของคุณ",
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: houseNumberController,
                    label: "บ้านเลขที่",
                  ),
                ),
                const SizedBox(width: 10), // Provide some spacing
                Expanded(
                  child: CustomTextField(
                    controller: groupController,
                    label: "หมู่",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: villageController,
              label: "หมู่บ้าน",
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: alleyController,
              label: "ซอย",
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: roadController,
              label: "ถนน",
            ),
            const SizedBox(height: 20),
            CustomTextField(
                controller: postCodeController,
                label: "รหัสไปรษณีย์",
                keyboardType: TextInputType.number,
                onChanged: (value) async {
                  if (value.length == 5) {
                    Map? data =
                        await fetchZipInfoService.getfetchZipInfo(value);
                    if (data != null) {
                      String district = await fetchZipInfoService
                          .translateEngToThai(data['place name']);
                      String province = await fetchZipInfoService
                          .translateEngToThai(data['state']);
                      setState(() {
                        provinceController.text = province;
                        districtController.text = district;
                      });
                    }
                  }
                }),
            const SizedBox(height: 20),
            CustomTextField(
              controller: provinceController,
              label: "จังหวัด",
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: districtController,
              label: "เขต/อำเภอ",
              readOnly: true,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: subDistrictController,
              label: "ตำบล/แขวง",
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nearbyPlacesController,
              label: "สถานที่ใกล้เคียง (สยาม,ดิโด้)",
            ),
            const SizedBox(height: 30),
            Center(
              child: BlueButton(
                label: "ต่อไป",
                onPressed: _isFormFilled
                    ? () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchLocationScreen(
                                currentPosition: Position(
                                    longitude: 100.523186,
                                    latitude: 13.736717,
                                    timestamp: DateTime.now(),
                                    accuracy: 0,
                                    altitude: 0,
                                    altitudeAccuracy: 0,
                                    heading: 0,
                                    headingAccuracy: 0,
                                    speed: 0,
                                    speedAccuracy: 0),
                                houseNumber: houseNumberController.text,
                                group: groupController.text,
                                village: villageController.text,
                                alley: alleyController.text,
                                road: roadController.text,
                                postCode: postCodeController.text,
                                province: provinceController.text,
                                district: districtController.text,
                                subDistrict: subDistrictController.text,
                                nearbyPlaces: nearbyPlacesController.text,
                                nameParking: nameParkkingController.text,
                              ),
                            ),
                          )
                        }
                    : () => {},
                color: _isFormFilled
                    ? AppColor.appPrimaryColor
                    : Colors.grey, // ปรับเปลี่ยนสีตามสถานะ
              ),
            ),
          ],
        ),
      ),
    );
  }
}
