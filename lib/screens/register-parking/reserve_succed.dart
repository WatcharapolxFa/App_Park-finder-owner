// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:parking_finder_app_provider/widgets/button_blue.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../assets/colors/constant.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ReserveSuccedScreen extends StatefulWidget {
//   const ReserveSuccedScreen(
//       {super.key,
//       required this.reserveID,
//       this.providerID,
//       this.orderID,
//       this.parkingID,
//       this.parkingName,
//       this.quantity,
//       this.price});
//   final String reserveID;
//   final String? providerID;
//   final String? orderID;
//   final String? parkingID;
//   final String? parkingName;
//   final double? quantity;
//   final int? price;

//   @override
//   ReserveSuccedScreenState createState() => ReserveSuccedScreenState();
// }

// class ReserveSuccedScreenState extends State<ReserveSuccedScreen> {
//   final storage = const FlutterSecureStorage();

//   void openLinePay(urlPayment) async {
//     final Uri url = Uri.parse(urlPayment);

//     if (!await launchUrl(url)) {
//       throw Exception('Could not launch $url');
//     }
//   }

//   Future<void> cacheUrl(String reserveID, String url) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(reserveID, url);
//   }

//   Future<String?> getCachedUrl(String reserveID) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString(reserveID);
//   }

//   void getUrlPayment() async {
//     String? cacheUrlCheck = await getCachedUrl(widget.reserveID);
//     if (cacheUrlCheck != null && cacheUrlCheck.isNotEmpty) {
//       openLinePay(cacheUrlCheck);
//       // ignore: use_build_context_synchronously
//       Navigator.pop(context);
//     } else {
//       String? accessToken = await storage.read(key: 'accessToken');
//       if (accessToken != null) {
//         try {
//           Map data = {
//             "provider_id": widget.providerID,
//             "order_id": widget.orderID,
//             "parking_id": widget.parkingID,
//             "parking_name": widget.parkingName,
//             "quantity": widget.quantity,
//             "price": widget.price,
//           };
//           String body = json.encode(data);
//           final url =
//               Uri.parse('${dotenv.env['HOST']}/customer/line-pay/payment');
//           final response = await http.post(
//             url,
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken'
//             },
//             body: body,
//           );

//           if (response.statusCode == 200) {
//             Map res = jsonDecode(response.body.toString());
//             await cacheUrl(widget.reserveID, res['message']);
//             openLinePay(res['message']);
//             // ignore: use_build_context_synchronously
//             Navigator.pop(context);
//             // ignore: use_build_context_synchronously
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => const LoggedInPage(
//                         screenIndex: 0,
//                       )),
//             );
//           } else {}
//         } catch (e) {
//           //fail
//         }
//       } else {
//         // ignore: use_build_context_synchronously
//         Navigator.pushNamed(context, '/login');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SvgPicture.asset(
//               'lib/assets/images/reserve_succed.svg',
//               width: 197,
//               height: 197,
//             ),
//             const SizedBox(height: 20.0),
//             const Text(
//               'ลงทะเบียนสำเร็จ!',
//               style: TextStyle(
//                   fontSize: 36.0,
//                   fontWeight: FontWeight.bold,
//                   color: AppColor.appPrimaryColor),
//             ),
//             const SizedBox(height: 20.0),
//             const Text(
//               'การลงทะเบียนที่จอด\nของคุณสำเร็จ\nรอการยืนยันที่จอดรถของคุณ\nสามารถติดสถานะได้ในแอพพลิเคชั่น',
//               style: TextStyle(
//                 fontSize: 14.0,
//                 color: Color(0xFFA6AAB4),
//               ),
//             ),
//             const SizedBox(height: 210.0),
//             BlueButton(
//               label: 'กลับสู่หน้าหลัก',
//               onPressed: () {
//                 getUrlPayment();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
