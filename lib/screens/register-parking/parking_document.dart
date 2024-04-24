import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/screens/register-parking/upload_documents.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';
import 'package:parking_finder_app_provider/widgets/button_white.dart';
import '../../assets/colors/constant.dart';

class ParkingDocumentScreen extends StatefulWidget {
  const ParkingDocumentScreen({super.key, required this.parkingID});
  final String parkingID;

  @override
  ParkingDocumentScreenState createState() => ParkingDocumentScreenState();
}

class ParkingDocumentScreenState extends State<ParkingDocumentScreen> {
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
              "เอกสารสำหรับการสมัคร",
              style: TextStyle(fontSize: 16, color: AppColor.appPrimaryColor),
            ),
            const SizedBox(height: 10),
            const Text(" • โฉนดที่ดิน",
                style: TextStyle(fontSize: 14, color: Colors.black)),
            const Text(" • หนังสือสำคัญแสดงสิทธิในที่ดิน",
                style: TextStyle(fontSize: 14, color: Colors.black)),
            const Text(" • ภาพบัตรประชาชน",
                style: TextStyle(fontSize: 14, color: Colors.black)),
            const Text(" • ภาพถ่ายวัดพื้นที่",
                style: TextStyle(fontSize: 14, color: Colors.black)),
            const Text(" • ภาพถ่ายที่อยู่โดยรวม",
                style: TextStyle(fontSize: 14, color: Colors.black)),
            const SizedBox(height: 10),
            const Text(
              "ตัวอย่างเอกสารสำหรับการสมัคร",
              style: TextStyle(fontSize: 16, color: AppColor.appPrimaryColor),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                 
                  child: Image.asset(
                    'lib/assets/images/chnode.png',
                    width: 119,
                    height: 178,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Image.asset(
                    'lib/assets/images/chnode2.png',
                    width: 127,
                    height: 178,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Image.asset(
                    'lib/assets/images/idCard.png',
                    width: 69,
                    height: 43,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child:  Image.asset(
                    'lib/assets/images/photoOfAreaMeasurement.png',
                    width: 127,
                    height: 176,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Image.asset(
                    'lib/assets/images/car_park.jpg',
                    width: 127,
                    height: 176,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            Center(
                child: BlueButton(
                    label: "ต่อไป",
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDocumentScreen(parkingID: widget.parkingID)));
                    })),
            const SizedBox(height: 20),
            Center(
                child: WhiteButton(
                    label: "แนบเอกสารเพิ่มภายหลัง",
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacementNamed(context, '/logged_in');
                    })),
          ],
        ),
      ),
    );
  }
}
