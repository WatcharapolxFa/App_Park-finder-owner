import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_finder_app_provider/models/history_model.dart';
import 'package:parking_finder_app_provider/models/parking_spot.dart';
import 'package:parking_finder_app_provider/models/profile_modal.dart';
import 'package:parking_finder_app_provider/screens/parking-manage/my_parking.dart';
import 'package:parking_finder_app_provider/services/history_service.dart';
import 'package:parking_finder_app_provider/services/parking_area_service.dart';
import 'package:parking_finder_app_provider/services/profile_service.dart';
import 'package:parking_finder_app_provider/widgets/feature_button.dart';
import 'package:parking_finder_app_provider/widgets/revenue_card.dart';
import 'package:parking_finder_app_provider/widgets/reservation_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.profit});
  final List? profit;
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final storage = const FlutterSecureStorage();
  final historyService = HistoryService();
  final profileService = ProfileService();
  final parkingAreaService = ParkingAreaService();
  List<History> historyList = [];
  bool _isLoading = false;
  Profile? profile = Profile(
      profileID: "",
      birthDay: "",
      email: "",
      firstName: "",
      lastName: "",
      phone: "",
      profilePictureURL: "",
      ssn: "");
  List<ParkingSpot> parkingAreaList = [];
  Map profit = {"count": 0};
  int totalSum = 0;

  @override
  void initState() {
    super.initState();
    loadProfile();
    loadHistory("on_working");
    loadProfit();
  }

  void loadProfit() async {
    final parkingAreas = await parkingAreaService.getMyArea();
    if (!mounted) return;
    setState(() {
      parkingAreaList = parkingAreas;
    });

    String parkingIDList =
        parkingAreaService.sumAllParkingAreaID(parkingAreaList);

    final res = await parkingAreaService.getProfit("monthly", parkingIDList);
    if (!mounted) return;
    setState(() {
      profit = res;
    });
    int sum = parkingAreaService.sumAllParkingArea(profit);
    setState(() {
      totalSum = sum;
    });
  }

  void loadProfile() async {
    profile = await profileService.getProfile();
  }

  Future<List<History>> loadHistory(String status) async {
    setState(() {
      _isLoading = true;
    });
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      final histories = await historyService.getHistory(status, accessToken);
      if (!mounted) return [];
      setState(() {
        historyList = histories;
        _isLoading = false;
      });
      return histories;
    } else {
      if (mounted) {
        Navigator.pushNamed(context, '/login');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 35),
            Row(
              children: [
                const Text(
                  "สวัสดี,",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    profile != null ? "คุณ  ${profile!.firstName}" : "คุณ",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FeatureButton(
                    title: "ลงทะเบียน\nที่จอด",
                    svgIconPath: 'lib/assets/icons/menu.svg',
                    onTap: () {
                      Navigator.pushNamed(context, "/parking_detail_register");
                    },
                  ),
                ),
                const SizedBox(width: 20), // ระยะห่างระหว่างปุ่ม
                Expanded(
                  child: FeatureButton(
                    title: "ที่จอดรถ\nของฉัน",
                    svgIconPath: 'lib/assets/icons/parking.svg',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyParkingScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("รายได้ของคุณ",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            CustomerRevenueCard(
                count: profit['count'], revenue: totalSum.toString()),
            const SizedBox(height: 20),
            if (_isLoading)
              const CupertinoPopupSurface(
                isSurfacePainted: false,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            Visibility(
              visible: historyList.isNotEmpty,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("การจองที่กำลังจะมา",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: historyList.isNotEmpty,
              child: historyList.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/history');
                      },
                      child: ReservationCard(reservation: historyList[0]),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
