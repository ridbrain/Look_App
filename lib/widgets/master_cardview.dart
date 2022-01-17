import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MasterCardView extends StatefulWidget {
  MasterCardView({
    required this.name,
    required this.photo,
    required this.experience,
    required this.reviews,
    required this.rating,
    required this.metro,
    required this.last,
    required this.onTap,
  });

  final String name;
  final String photo;
  final String experience;
  final String reviews;
  final double? rating;
  final String metro;
  final bool last;
  final Function() onTap;

  @override
  _MasterCardViewState createState() => _MasterCardViewState();
}

class _MasterCardViewState extends State<MasterCardView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100,
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag: widget.photo,
                          child: Container(
                            width: 60,
                            height: 75,
                            child: ClipRRect(
                              borderRadius: Constants.radius,
                              child: CachedNetworkImage(
                                imageUrl: widget.photo,
                                placeholder: (context, url) =>
                                    CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                                width: 60,
                                height: 75,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: Constants.radius,
                              boxShadow: Constants.shadow,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 75,
                          height: 75,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 5,
                                child: widget.rating != null
                                    ? Container(
                                        alignment: Alignment.center,
                                        height: 18,
                                        width: 28,
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey[900],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          widget.rating.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            widget.experience,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            widget.reviews,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 15),
                            child: Text(
                              widget.metro,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      height: 1,
                      color: widget.last
                          ? Colors.transparent
                          : Colors.grey.withOpacity(0.1),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingMasterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 110,
                child: Stack(
                  children: [
                    Center(
                      child: Shimmer(
                        width: 55,
                        height: 70,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Shimmer(
                                height: 15,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Shimmer(
                                height: 13,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Shimmer(
                                height: 13,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Shimmer(
                                height: 13,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox.shrink(),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
