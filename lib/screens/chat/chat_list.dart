import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_finder_app_provider/models/profile_modal.dart';
import 'package:parking_finder_app_provider/screens/chat/chat.dart';
import 'package:parking_finder_app_provider/services/profile_service.dart';

// ตัวอย่างโมเดลของผู้ใช้ที่สามารถสนทนาด้วยได้
class ChatUser {
  final String id;
  final String name;
  final String lastMessage;
  final String avatarUrl;

  ChatUser({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.avatarUrl,
  });
}

final List<ChatUser> chatUsers = [
  ChatUser(
    id: '1',
    name: 'John Doe',
    lastMessage: 'Hello, how are you?',
    avatarUrl: 'https://via.placeholder.com/150',
  ),
  ChatUser(
    id: '2',
    name: 'Jane Doe',
    lastMessage: 'Hi, I am good!',
    avatarUrl: 'https://via.placeholder.com/150',
  ),
];

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});
  @override
  State<ChatListScreen> createState() => ChatListState();
}

class ChatListState extends State<ChatListScreen> {
  final storage = const FlutterSecureStorage();
  final profileService = ProfileService();
  List messageList = [];
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

  @override
  void initState() {
    super.initState();
    loadMessage();
    loadProfile();
  }

  void loadMessage() async {
    setState(() {
      _isLoading = true;
    });
    final response = await retrieveMessageList();
    if (!mounted) return;
    setState(() {
      messageList = response;
      _isLoading = false;
    });

  }

  void loadProfile() async {
    profile = await profileService.getProfile();

    // bool idExists = flutterList.any((element) => element["ID"] == inputId);
  }

  Future retrieveMessageList() async {
    final url =
        Uri.parse('${dotenv.env['HOST']}/provider/retrive_message_list');

    // ดึง token จาก storage
    String? token = await storage.read(key: 'accessToken');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ใส่ token ใน header
      },
    );

    // print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      return data;
    } else {
      return [];
    }
  }

  String filterListID(List<dynamic> groupList, String id) {
    List<dynamic> filteredList =
        groupList.where((map) => map["ID"] != id).toList();
    return filteredList[0]['ID'];
  }

  String filterListFullName(List<dynamic> groupList, String id) {
    List<dynamic> filteredList =
        groupList.where((map) => map["ID"] != id).toList();
    return filteredList[0]['FullName'];
  }

  String filterListImageUrl(List<dynamic> groupList, String id) {
    List<dynamic> filteredList =
        groupList.where((map) => map["ID"] != id).toList();
    if (filteredList[0]['ImageURL'].toString().startsWith(
        "https://parkingadmindata.s3.ap-southeast-1.amazonaws.com")) {
      return filteredList[0]['ImageURL'];
    } else {
      return 'https://via.placeholder.com/150';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการแชท'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLoading)
             const Padding(padding: EdgeInsets.only(top: 10),child:  CupertinoPopupSurface(
                isSurfacePainted: false,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),),
            ...messageList.map((data) => InkWell(
                  onTap: () {
                    final receiverID =
                        filterListID(data['group_list'], profile!.profileID);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                reserveID: data['reservation_id'],
                                senderID: profile!.profileID,
                                receiverID: receiverID)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              filterListImageUrl(
                                  data['group_list'], profile!.profileID),
                              scale: 150),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filterListFullName(
                                  data['group_list'], profile!.profileID)),
                              const Text("")
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14)
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
      // ListView.builder(
      //   itemCount: chatUsers.length,
      //   itemBuilder: (context, index) {
      //     final user = chatUsers[index];
      // return ListTile(
      // leading: CircleAvatar(
      //   backgroundImage: NetworkImage(user.avatarUrl),
      // ),
      //   title: Text(user.name),
      //   subtitle: Text(user.lastMessage),
      //   onTap: () {
      //     // ที่นี่คุณสามารถเพิ่มการนำทางไปยังหน้าแชทกับผู้ใช้เฉพาะ
      //     print('Tapped on ${user.name}');
      //   },
      // );
      //   },
      // ),
    );
  }
}
