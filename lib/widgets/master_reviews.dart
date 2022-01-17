import 'package:look_app/pages/reviews.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/review.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class MasterReviews extends StatefulWidget {
  MasterReviews({
    required this.masterId,
  });

  final int masterId;

  @override
  _MasterReviewsState createState() => _MasterReviewsState();
}

class _MasterReviewsState extends State<MasterReviews> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetHandler.getReviews(widget.masterId.toString()),
      builder: (context, AsyncSnapshot<List<Review>?> snap) {
        if (snap.hasData) {
          if (snap.data!.isNotEmpty) {
            return Container(
              child: Column(
                children: [
                  GroupLabel(
                    label: "Отзывы",
                    link: snap.data!.length.toString(),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ReviewsPage(
                            reviews: snap.data!,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    height: 180,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ReviewCell(
                          review: snap.data![index],
                          width: snap.data!.length != 1
                              ? MediaQuery.of(context).size.width - 60
                              : MediaQuery.of(context).size.width - 30,
                          margin: const EdgeInsets.only(left: 15),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: snap.data!.length >= 3 ? 3 : snap.data!.length,
                      padding: const EdgeInsets.only(right: 15),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        } else {
          return LoadingReviews();
        }
      },
    );
  }
}

class LoadingReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Shimmer(
                  height: 14,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Shimmer(
                  height: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 15),
            itemCount: 2,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Shimmer(
                  height: 180,
                  width: MediaQuery.of(context).size.width - 60,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
