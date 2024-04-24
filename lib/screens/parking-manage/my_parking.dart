import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parking_finder_app_provider/screens/parking-manage/parking_detail_edit.dart';
import 'package:parking_finder_app_provider/screens/register-parking/parking_document.dart';

import 'package:parking_finder_app_provider/services/parking_area_service.dart';
import 'package:parking_finder_app_provider/widgets/my_parking/parking_my_card.dart';
import 'package:parking_finder_app_provider/models/parking_spot.dart';
class MyParkingScreen extends StatefulWidget {
  const MyParkingScreen({super.key});
  @override
  MyParkingState createState() => MyParkingState();
}

class MyParkingState extends State<MyParkingScreen> {
  final parkingAreaService = ParkingAreaService();
  List<ParkingSpot> parkingAreaList = [];
  bool _isLoadParking = false;

  @override
  void initState() {
    super.initState();
    _loadParkingArea();
  }

  void _loadParkingArea() async {
    setState(() {
      _isLoadParking = true;
    });
    final parkingAreas = await parkingAreaService.getMyArea();
    if (!mounted) return;
    setState(() {
      parkingAreaList = parkingAreas;
      _isLoadParking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ที่จอดรถของฉัน'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (_isLoadParking)
                const CupertinoPopupSurface(
                  isSurfacePainted: false,
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                ),
              ...parkingAreaList.map((data) => InkWell(
                    onTap: () {
                      if (data.statusApply == "accepted") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParkingDetailEditScreen(
                                      parkingDetail: data,
                                    )));
                      } else if (data.statusApply == "wait for document") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParkingDocumentScreen(
                                    parkingID: data.parkingID)));
                      }
                      else if (data.statusApply == "denied"){
                       EasyLoading.showInfo(data.statusApplyDetail);
                      }
                      else if (data.statusApply == "apply completed"){
                        EasyLoading.showInfo("รอ Admin อนุมัติการสมัครของคุณ");
                      }
                    },
                    child: ParkingMyCard(detail: data),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
