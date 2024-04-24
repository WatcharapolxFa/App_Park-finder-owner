import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parking_finder_app_provider/services/parking_area_service.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:parking_finder_app_provider/widgets/button_editable.dart';
import 'package:parking_finder_app_provider/widgets/button_slot_parking.dart';
import 'package:parking_finder_app_provider/widgets/upload_button.dart';
import '../../assets/colors/constant.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key, required this.parkingID});
  final String parkingID;

  @override
  UploadDocumentScreenState createState() => UploadDocumentScreenState();
}

class UploadDocumentScreenState extends State<UploadDocumentScreen> {
  final parkingAreaService = ParkingAreaService();
  ImagePicker picker = ImagePicker();
  XFile? parkingimage;
  XFile? landTitleDeedimage;
  XFile? landRightsCertificateimage;
  XFile? idCardimage;
  List<XFile>? measurementimage;
  List<XFile>? overallAreaimage;
  int parkingImageCount = 0;
  int uploadedDocumentAllCount = 0;
  int landTitleDeedPictureCount = 0;
  int landRightsCertificateCount = 0;
  int idCardPictureCount = 0;
  int photoOfAreaMeasurement = 0;
  int photoOfOverallArea = 0;
  int totalParkingCount = 1;
  final TextEditingController priceController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
  }

  void _uploadDocument(String imageType) async {
    // ตรงนี้คุณต้องใช้โค้ดสำหรับเปิด file picker และอัปโหลดเอกสาร
    // สมมติว่ามีการอัปโหลดเอกสารสำเร็จ จะเรียกใช้ setState ด้านล่างนี้เพื่ออัปเดต UI

    if (imageType == "parking") {
      parkingimage = await picker.pickImage(source: ImageSource.gallery);
      if (parkingimage != null) {
        setState(() {
          parkingImageCount += 1;
        });
      }
    } else if (imageType == "titleDeed") {
      landTitleDeedimage = await picker.pickImage(source: ImageSource.gallery);
      if (landTitleDeedimage != null) {
        setState(() {
          landTitleDeedPictureCount += 1;
        });
      }
    } else if (imageType == "landCertificate") {
      landRightsCertificateimage =
          await picker.pickImage(source: ImageSource.gallery);
      if (landRightsCertificateimage != null) {
        setState(() {
          landRightsCertificateCount += 1;
        });
      }
    } else if (imageType == "idCard") {
      idCardimage = await picker.pickImage(source: ImageSource.gallery);
      if (idCardimage != null) {
        setState(() {
          idCardPictureCount += 1;
        });
      }
    } else if (imageType == "measurement") {
      measurementimage = await picker.pickMultiImage();
      if (measurementimage!.isNotEmpty) {
        setState(() {
          photoOfAreaMeasurement += measurementimage!.length;
        });
      }
    } else if (imageType == "overView") {
      overallAreaimage = await picker.pickMultiImage();
      if (overallAreaimage!.isNotEmpty) {
        setState(() {
          photoOfOverallArea += overallAreaimage!.length;
        });
      } 
    }

    setState(() {
      uploadedDocumentAllCount += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ลงทะเบียนที่จอดรถ"),
        backgroundColor: AppColor.appPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                " สามารถอัปโหลดเอกสารได้ในรูปแบบไฟล์ .pdf หรือ .jpg เท่านั้น",
                style: TextStyle(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 10),
            Text(
              "อัปโหลดเอกสาร ($uploadedDocumentAllCount)",
              style: const TextStyle(
                  fontSize: 16, color: AppColor.appPrimaryColor),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColor.blackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ภาพที่จอดรถ",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text("($parkingImageCount/1)",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: parkingimage == null
                  ? UploadButtonWidget(onPressed: () {
                      _uploadDocument("parking");
                    })
                  : Image.file(
                      File(parkingimage!.path),
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColor.blackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("โฉนดที่ดิน",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text("($landTitleDeedPictureCount/1)",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: landTitleDeedimage == null
                  ? UploadButtonWidget(onPressed: () {
                      _uploadDocument("titleDeed");
                    })
                  : Image.file(
                      File(landTitleDeedimage!.path),
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColor.blackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("หนังสือสำคัญแสดงสิทธิในที่ดิน",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text("($landRightsCertificateCount/1)",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: landRightsCertificateimage == null
                  ? UploadButtonWidget(onPressed: () {
                      _uploadDocument("landCertificate");
                    })
                  : Image.file(
                      File(landRightsCertificateimage!.path),
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColor.blackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ภาพบัตรประชาชน",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text("($idCardPictureCount/1)",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: idCardimage == null
                  ? UploadButtonWidget(onPressed: () {
                      _uploadDocument("idCard");
                    })
                  : Image.file(
                      File(idCardimage!.path),
                      fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColor.blackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ภาพถ่ายวัดพื้นที่",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text("($photoOfAreaMeasurement/$totalParkingCount)",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: measurementimage != null && measurementimage!.isNotEmpty
                  ? Row(
                      children: measurementimage!.map((image) {
                        return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.file(
                              File(image.path),
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ));
                      }).toList(),
                    )
                  : UploadButtonWidget(onPressed: () {
                      _uploadDocument("measurement");
                    }),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColor.blackgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("ภาพถ่ายโดยรวมของที่จอด",
                      style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text("($photoOfOverallArea/$totalParkingCount)",
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: overallAreaimage != null && overallAreaimage!.isNotEmpty
                  ? Row(
                      children: overallAreaimage!.map((image) {
                        return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.file(
                              File(image.path),
                              fit: BoxFit.fill,
                              width: 100,
                              height: 100,
                            ));
                      }).toList(),
                    )
                  : UploadButtonWidget(onPressed: () {
                      _uploadDocument("overView");
                    }),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft, // จัดให้ข้อความชิดซ้าย
              child: Text(
                'ข้อมูลที่จอดรถเพิ่มเติม',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColor.appPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ParkingSlotCounter(
              onCounterChanged: (int newCounterValue) {
                setState(() {
                  totalParkingCount = newCounterValue;
                });
              },
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft, // จัดให้ข้อความชิดซ้าย
              child: Text(
                'ราคาที่จอดรถต่อชั่วโมง',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            EditablePriceButton(
              initialPrice: double.tryParse(priceController.text) ??
                  00, // ใช้ค่าจาก priceController หรือค่าเริ่มต้นเป็น 75 หากแปลงไม่ได้
              onPriceChanged: (newPrice) {
                setState(() {
                  priceController.text =
                      newPrice.toString(); // อัปเดตค่าใน priceController
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
                child: BlueButton(
                    label: "ยืนยันการส่งเอกสาร",
                    onPressed: () async {
                      EasyLoading.show();

                      String parkingPictureURL =
                          await parkingAreaService.uploadParkingIMG(
                              widget.parkingID,
                              "parkingIMG",
                              parkingimage!.path);

                      String titleDeedURL =
                          await parkingAreaService.uploadParkingIMG(
                              widget.parkingID,
                              "titleDeedIMG",
                              landTitleDeedimage!.path);

                      String landCertificateURL =
                          await parkingAreaService.uploadParkingIMG(
                              widget.parkingID,
                              "certificateIMG",
                              landRightsCertificateimage!.path);

                      String idCardURL =
                          await parkingAreaService.uploadParkingIMG(
                              widget.parkingID, "idCardIMG", idCardimage!.path);
                      List<String> overViewPictureURL = [];
                      for (int i = 0; i < overallAreaimage!.length; i++) {
                        String img = await parkingAreaService.uploadParkingIMG(
                            widget.parkingID,
                            "overallAreaimage_${i}_IMG",
                            overallAreaimage![i].path);
                        overViewPictureURL.add(img);
                      }
                      List<String> measurementPictureURL = [];
                      for (int i = 0; i < measurementimage!.length; i++) {
                        String img = await parkingAreaService.uploadParkingIMG(
                            widget.parkingID,
                            "measurement_${i}_IMG",
                            measurementimage![i].path);
                        measurementPictureURL.add(img);
                      }
                      double doubleValue = double.parse(priceController.text);
                      int intValue = doubleValue.toInt();

                      final response =
                          await parkingAreaService.registerAreaDocument(
                              widget.parkingID,
                              parkingPictureURL,
                              titleDeedURL,
                              landCertificateURL,
                              idCardURL,
                              totalParkingCount,
                              intValue,
                              overViewPictureURL,
                              measurementPictureURL);
                      if (response) {
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess("บันทึกสำเร็จ");
                        // ignore: use_build_context_synchronously
                        Navigator.popUntil(context, (route) => route.isFirst);
                        // ignore: use_build_context_synchronously
                        Navigator.pushReplacementNamed(context, '/logged_in');
                      }
                      else {
                        EasyLoading.dismiss();
                        EasyLoading.showError("บันทึกไม่สำเร็จ");
                      }
                    })),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
