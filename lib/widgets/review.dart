import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/widgets/convert_date.dart';
import 'package:flutter/material.dart';

class ReviewCell extends StatelessWidget {
  ReviewCell({
    required this.review,
    this.width,
    this.margin = const EdgeInsets.fromLTRB(15, 10, 15, 5),
  });

  final Review review;
  final double? width;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 180,
      margin: margin,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: Constants.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.name!,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                review.stars.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              )
            ],
          ),
          Container(
            height: 1,
          ),
          Text(
            ConvertDate(context).fromUnix(
              review.date!,
              'dd.MM.yy',
            ),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Container(
            height: 10,
          ),
          Text(
            review.message!.isEmpty ? "Оценка без отзыва" : review.message!,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
