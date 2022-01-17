import 'package:look_app/services/answer.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/review.dart';
import 'package:flutter/material.dart';

class ReviewsPage extends StatefulWidget {
  ReviewsPage({
    required this.reviews,
  });

  final List<Review> reviews;

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(
              "Отзывы",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ReviewCell(
                  review: widget.reviews[index],
                );
              },
              childCount: widget.reviews.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
