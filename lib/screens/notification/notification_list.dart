import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:parking_finder_app_provider/models/notification_modal.dart';
import 'package:parking_finder_app_provider/services/notification_service.dart';
import 'package:parking_finder_app_provider/services/profile_service.dart';
import 'package:parking_finder_app_provider/widgets/notification/reservation_tile.dart';
import '../../assets/colors/constant.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});
  @override
  NotificationListScreenState createState() => NotificationListScreenState();
}

class NotificationListScreenState extends State<NotificationListScreen> {
  final storage = const FlutterSecureStorage();
  late NotificationService notificationService;
  ProfileService profileService = ProfileService();
  List<Notifications> notifications = [];
  bool _isLoadNotifications = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  void loadProfile() async {
    var profile = await profileService.getProfile();
    notificationService = NotificationService(
      userID: profile!.profileID,
      onNotificationReceived: (Notifications message) {
        if (mounted) {
          setState(() {
            notifications.insert(0, message);
          });
        }
      },
    );
    loadNotification();
  }

  void loadNotification() async {
    setState(() {
      _isLoadNotifications = true;
    });
    notifications = await notificationService.retrieveNotificationLog();
    if (!mounted) return;
    setState(() {
      _isLoadNotifications = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("การแจ้งเตือน",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        centerTitle: true,
        backgroundColor: AppColor.appPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          if (_isLoadNotifications)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: CupertinoPopupSurface(
                isSurfacePainted: false,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ),
          ...notifications.map((data) => Column(
                children: [
                  NotificationCard(
                    title: data.title,
                    description: data.description,
                    callbackMethod: data.callbackMethod,
                    date: data.time,
                  ),
                ],
              )),
        ]),
      ),
    );
  }
}
