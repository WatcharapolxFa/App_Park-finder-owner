import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

class CustomerRevenueCard extends StatefulWidget {
  const CustomerRevenueCard(
      {super.key, required this.count, required this.revenue});
  final int count;
  final String revenue;
  @override
  CustomerRevenueCardState createState() => CustomerRevenueCardState();
}

class CustomerRevenueCardState extends State<CustomerRevenueCard> {
  // int customerCount = 145; // ตัวอย่างข้อมูล
  String revenue = "26k"; // ตัวอย่างข้อมูล

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 152,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.backgroundNavbar,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // กล่องซ้าย
          Expanded(
            child: _buildLeftSection(widget.count.toString()),
          ),
          const SizedBox(width: 10),
          // กล่องขวา
          Expanded(
            child:
                _buildRightSection(widget.revenue), // สามารถใช้ตัวแปร revenue แทน "26k"
          ),
        ],
      ),
    );
  }

  Widget _buildLeftSection(String customerCount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "จำนวนลูกค้า",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              customerCount,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSection(String revenue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "รายได้",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          revenue, // ใช้ตัวแปร revenue
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
