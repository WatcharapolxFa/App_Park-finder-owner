import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';
import 'package:parking_finder_app_provider/screens/notification/notification_detail.dart';

class NotificationCard extends StatefulWidget {
  final String title;
  final String description;
  final List? callbackMethod;
  final DateTime date;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    this.callbackMethod,
    required this.date,
  });
  @override
  NotificationCardState createState() => NotificationCardState();
}

class NotificationCardState extends State<NotificationCard> {

  Widget notificationIcon(){
    if (widget.title == "ที่จอดรถของคุณมีการอัพเดทสถานะ") {
      final status = widget.description.split(" ").last;
      if (status == "accepted"){
        return const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 35,
                ),
              );
      } else if (status == "denied"){
        return const Center(
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 35,
                ),
              );
      }else {
      return const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w900),
                ),
              );
    }
    }
    else {
      return const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w900),
                ),
              );
    }
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.title == "โปรดยืนยันการจองของผู้ใช้งาน") {
          final description = widget.description.split("|")[0];
          final parkingName = widget.description.split("|")[1];
          final startDate = widget.description.split("|")[2];
          final endDate = widget.description.split("|")[3];
          final hourStart = widget.description.split("|")[4];
          final hourEnd = widget.description.split("|")[5];
          final minStart = widget.description.split("|")[6];
          final minEnd = widget.description.split("|")[7];
          final price = widget.description.split("|")[8];
          final callBackConfirm = widget.callbackMethod![0]['call_back_url'];
          final callBackCancel = widget.callbackMethod![1]['call_back_url'];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationDetailScreen(
                        typeNotification: "approve",
                        title: widget.title,
                        description: description,
                        parkingName: parkingName,
                        startDate: startDate,
                        endDate: endDate,
                        entryTime: TimeOfDay(
                            hour: int.parse(hourStart),
                            minute: int.parse(minStart)),
                        exitTime: TimeOfDay(
                            hour: int.parse(hourEnd),
                            minute: int.parse(minEnd)),
                        price: int.parse(price),
                        callBackConfirm: callBackConfirm,
                        callBackCancel: callBackCancel,
                      )));
        }
        else if (widget.title == "ที่จอดรถของคุณมีการอัพเดทสถานะ"){
          Navigator.pushNamed(context, "/my_parking");
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                color: AppColor.appPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: notificationIcon(),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // ทำให้ Column มีขนาดพอดีกับเนื้อหา
                children: [
                  Text(widget.title,
                      style: const TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis),
                  Text(
                    widget.description.split("|")[0],
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    DateFormat("yyyy-MM-dd HH:mm:ss").format(widget.date),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
