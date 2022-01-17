import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/extensions.dart';
import 'package:look_app/widgets/convert_date.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordCardView extends StatelessWidget {
  RecordCardView({
    required this.record,
    required this.onTap,
  });

  final Record record;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(2, 0, 0, 7),
            alignment: Alignment.centerLeft,
            child: Text(
              ConvertDate(context).fromUnix(
                record.start,
                "dd MMMM в HH:mm",
              ),
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ),
          Material(
            color: Colors.grey[100],
            borderRadius: Constants.radius,
            child: InkWell(
              borderRadius: Constants.radius,
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: Constants.radius,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            spreadRadius: 1,
                            blurRadius: 7,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: Constants.radius,
                        child: CachedNetworkImage(
                          imageUrl: record.imageUrl,
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: 60,
                          height: 75,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            record.prices.getString().capitalLetter(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            record.place.address,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingRecordCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(
            width: 150,
            height: 15,
          ),
          SizedBox(
            height: 10,
          ),
          Shimmer(
            height: 80,
          ),
        ],
      ),
    );
  }
}
