import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:parking_finder_app_provider/screens/account/add_account.dart';
import 'package:parking_finder_app_provider/screens/account/profile_edit.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:parking_finder_app_provider/widgets/button_blue.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  final logger = Logger();
  final storage = const FlutterSecureStorage();

  Map<String, dynamic> profile = {
    'profile_picture_url': '',
    'first_name': '',
    'last_name': '',
    'email': ''
  };

  @override
  void initState() {
    super.initState();
    initProfile();
    getProfile();
  }

  void initProfile() async {
    String? firstName = await storage.read(key: 'firstName');
    String? lastName = await storage.read(key: 'lastName');
    String? email = await storage.read(key: 'email');
    String? pictureURL = await storage.read(key: 'pictureURL');
    setState(() {
      profile = {
        'profile_picture_url': pictureURL,
        'first_name': firstName,
        'last_name': lastName,
        'email': email
      };
    });
  }

  void getProfile() async {
    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      try {
        final url = Uri.parse('${dotenv.env['HOST']}/provider/profile');
        final response = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken'
          },
        );
        if (response.statusCode == 200) {
          setState(() {
            profile = jsonDecode(response.body.toString())['profile'];
          });
          String? firstName = await storage.read(key: 'firstName');
          String? lastName = await storage.read(key: 'lastName');
          String? email = await storage.read(key: 'email');
          String? pictureURL = await storage.read(key: 'pictureURL');

          if (profile['first_name'] != firstName) {
            await storage.write(key: 'firstName', value: profile['first_name']);
          }
          if (profile['last_name'] != lastName) {
            await storage.write(key: 'lastName', value: profile['last_name']);
          }
          if (profile['email'] != email) {
            await storage.write(key: 'email', value: profile['email']);
          }
          if (profile['profile_picture_url'] != pictureURL) {
            await storage.write(
                key: 'pictureURL', value: profile['profile_picture_url']);
          }
        } else {
          throw Exception('Failed to load data');
        }
      } catch (e) {
        // Failed to load data from Backend
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า'),
        centerTitle: true,
        backgroundColor: AppColor.appPrimaryColor,
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: profile['profile_picture_url'] == ""
                  ? Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                      ),
                      child: const Icon(Icons.person, size: 30),
                    )
                  : Image.network(
                      (profile['profile_picture_url']),
                      key: ValueKey(Random().nextInt(100)),
                      fit: BoxFit.fill,
                      width: 60,
                      height: 60,
                    ),
            ),
            title: Text('${profile['first_name']} ${profile['last_name']}'),
            subtitle: Text('${profile['email']}'),
          ),
          const Divider(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileEditPage(
                    profileID: profile['_id'],
                    name: profile['first_name'],
                    lastName: profile['last_name'],
                    phoneNumber: profile['phone'],
                    idCard: profile['ssn'],
                    birthDay: profile['birth_day'],
                    profileURL: profile['profile_picture_url'],
                    onEdit: () {
                      setState(() {});
                    },
                  ),
                ),
              );
            },
            child: const ListTile(
              title: Text('แก้ไขโปรไฟล์ส่วนตัว'),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddAccountPage(
                            profileID: profile['_id'],
                          )));
            },
            child: const ListTile(
              title: Text('จัดการบัญชีของคุณ'),
              trailing: Icon(Icons.arrow_forward_ios, size: 14),
            ),
          ),

          // const ListTile(
          //   leading: Icon(Icons.info),
          //   title: Text('ข้อกำหนดและเงื่อนไข'),
          // ),
          // const ListTile(
          //   leading: Icon(Icons.shield),
          //   title: Text('นโยบายความเป็นส่วนตัว'),
          // ),
          const SizedBox(height: 440),
          Center(
            child: BlueButton(
              label: 'ออกจากระบบ',
              onPressed: () async {
                const storage = FlutterSecureStorage();
                String? accessToken = await storage.read(key: 'accessToken');
                if (accessToken != null) {
                  try {
                    final url =
                        Uri.parse('${dotenv.env['HOST']}/provider/logout');
                    await http.post(
                      url,
                      headers: {
                        "Content-Type": "application/json",
                        'Authorization': 'Bearer $accessToken'
                      },
                    );

                    await storage.deleteAll();
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // ignore: use_build_context_synchronously
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacementNamed(context, '/login');
                    });
                  } catch (e) {
                    // Failed to load data from Backend
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
