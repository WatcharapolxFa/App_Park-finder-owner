import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final Map review;

  const ReviewItem({Key? key, required this.review}) : super(key: key);

  String calculateTimeDifference(String timestampString) {
    DateTime commentTime = DateTime.parse(timestampString);
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(commentTime);

    if (difference.inHours < 24) {
      return "${difference.inHours} ชั่วโมงที่แล้ว";
    } else {
      return "${difference.inDays} วันที่แล้ว";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${review['first_name']} ${review['last_name']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(calculateTimeDifference(review['time_stamp'])),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review['review_score'] ? Icons.star : Icons.star_border,
                color: index < review['review_score'] ? Colors.yellow : Colors.grey,
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 5),
          Text(review['comment']),
          const Divider(),
        ],
      ),
    );
  }
}
