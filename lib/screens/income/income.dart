import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parking_finder_app_provider/models/parking_spot.dart';
import 'package:parking_finder_app_provider/services/parking_area_service.dart';
import 'package:parking_finder_app_provider/widgets/income_chart.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parking_finder_app_provider/widgets/custom_dropdown.dart';
import 'package:parking_finder_app_provider/widgets/revenue_card.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});
  @override
  IncomeScreenState createState() => IncomeScreenState();
}

class IncomeScreenState extends State<IncomeScreen> {
  final parkingAreaService = ParkingAreaService();
  List<ParkingSpot> parkingAreaList = [];
  int totalParkingArea = 0;
  List<String> dropdownItems = [
    'ทั้งหมด',
  ];
  List<String> dropdownIDItems = [];
  Map profit = {"count": 0, "date":[]};
  int totalSum = 0;

  @override
  void initState() {
    super.initState();
    _loadParkingArea();
  }

  void _loadParkingArea() async {
    EasyLoading.show();
    final parkingAreas = await parkingAreaService.getMyArea();
    if (!mounted) return;
    List<String> listOfParkingName =
        parkingAreas.map((map) => map.parkingName).toList();
    setState(() {
      parkingAreaList = parkingAreas;
      totalParkingArea = parkingAreas.length;
      dropdownItems.addAll(listOfParkingName);
    });
    String type = mapThToEng(dropdownValueFilter);
    loadProfitInit(type);
  }

  String mapThToEng(String textTH) {
    String textEng = "";
    if (textTH == "รายวัน") {
      textEng = "daily";
    } else if (textTH == "รายสัปดาห์") {
      textEng = "weekly";
    } else if (textTH == "รายเดือน") {
      textEng = "monthly";
    } else if (textTH == "รายปี") {
      textEng = "yearly";
    }
    return textEng;
  }

  void loadProfitInit(String type) async {
    String parkingIDList =
        parkingAreaService.sumAllParkingAreaID(parkingAreaList);
    dropdownIDItems.add(parkingIDList);
    List<String> listOfParkingID =
        parkingAreaList.map((map) => map.parkingID).toList();
    dropdownIDItems.addAll(listOfParkingID);

    final res = await parkingAreaService.getProfit(type, parkingIDList);
    EasyLoading.dismiss();
    setState(() {
      profit = res;
    });
    int sum = parkingAreaService.sumAllParkingArea(profit);
    setState(() {
      totalSum = sum;
    });
 
  }

  void loadProfit(String type, String parkingIDList) async {
    final res = await parkingAreaService.getProfit(type, parkingIDList);
EasyLoading.dismiss();
    setState(() {
      profit = res;
    });
    int sum = parkingAreaService.sumAllParkingArea(profit);
    setState(() {
      totalSum = sum;
    });
  }

  int filterMonths = 1;

  final List<dynamic> incomeData = [{"date":"2024-02-01 - 2024-02-07","sum":0},{"date":"2024-02-08 - 2024-02-14","sum":60},{"date":"2024-02-15 - 2024-02-21","sum":453},{"date":"2024-02-22 - 2024-02-28","sum":30},{"date":"2024-02-29 - 2024-02-29","sum":10}];
  String dropdownValue = 'ทั้งหมด';

  String dropdownValueFilter = 'รายเดือน';
  final List<String> dropdownOptions = [
    'รายวัน',
    'รายสัปดาห์',
    'รายเดือน',
    'รายปี'
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: screenWidth * 0.95,
                  height: 73,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        AppColor.grapPuple,
                        AppColor.appPrimaryColor,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "จำนวนที่จอดรถ\n$totalParkingArea",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // DropdownButton widget
              Container(
                width: screenWidth * 0.95,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white, // ใช้สีที่ต้องการสำหรับพื้นหลัง
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: Row(
                    children: [
                      const Spacer(), // ใช้ Spacer ผลักข้อความและไอคอนไปทางด้านขวา
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: SvgPicture.asset(
                          'lib/assets/icons/dropdown.svg',
                          width: 16,
                          height: 16,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            EasyLoading.show();
                            String type = mapThToEng(dropdownValueFilter);
                            int index = dropdownItems.indexOf(dropdownValue);
                            loadProfit(type, dropdownIDItems[index]);
                          });
                        },
                        items: dropdownItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        isExpanded:
                            false, // Prevent DropdownButton from expanding to full width
                        alignment: Alignment
                            .centerRight, // Align the icon and text to the right
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColor.grapPuple, // สีม่วง
                        borderRadius: BorderRadius.circular(4), // มุมโค้ง 4px
                      ),
                    ),
                    const SizedBox(
                        width: 8), // ช่องว่างระหว่างสี่เหลี่ยมและข้อความ
                    const Text('ภาพรวมรายได้',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(
                        width: 100), // ช่องว่างระหว่างข้อความและ dropdown
                    Expanded(
                      // ใช้ Expanded เพื่อให้ dropdown ขยายเต็มพื้นที่ที่เหลือ
                      child: CustomDropdown(
                        options:
                            dropdownOptions, // ใช้ dropdownItems ที่มีข้อมูลตัวเลือกจริง
                        initialValue:
                            dropdownValueFilter, // ใช้ dropdownValue ที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น
                        onChanged: (newValue) {
                          if (newValue != null &&
                              dropdownOptions.contains(newValue)) {
                            setState(() {
                              dropdownValueFilter = newValue;
                              EasyLoading.show();
                              String type = mapThToEng(dropdownValueFilter);
                              int index = dropdownItems.indexOf(dropdownValue);
                              loadProfit(type, dropdownIDItems[index]);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomerRevenueCard(
                  count: profit['count'], revenue: totalSum.toString()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 16,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColor.appPrimaryColor, // สีม่วง
                        borderRadius: BorderRadius.circular(4), // มุมโค้ง 4px
                      ),
                    ),
                    const SizedBox(
                        width: 8), // ช่องว่างระหว่างสี่เหลี่ยมและข้อความ
                    const Text('รายได้เฉลี่ย',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  height: screenHeight / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: IncomeChart(
                      incomeData: profit['date'].length > 0 ? profit['date'] : incomeData,
                      dropdownValueFilter: dropdownValueFilter,
                      filterMonths: filterMonths,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
