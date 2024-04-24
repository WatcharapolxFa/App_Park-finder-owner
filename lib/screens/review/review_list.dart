import 'package:flutter/material.dart';
import 'package:parking_finder_app_provider/widgets/review/review_item.dart';

class ReviewList extends StatelessWidget {
  final List reviews; // Assuming your reviews are stored in a list of maps

  const ReviewList({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("รีวิว",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            // Use ReviewItem for each review
            return ReviewItem(review: reviews[index]);
          },
        ),
      ),
    );
  }
}
