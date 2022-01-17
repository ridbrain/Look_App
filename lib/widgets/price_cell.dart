import 'dart:ui';

import 'package:look_app/services/answer.dart';
import 'package:look_app/services/extensions.dart';
import 'package:flutter/material.dart';

class PriceCell extends StatelessWidget {
  PriceCell({
    required this.price,
    this.last = false,
    this.onTap,
  });

  final Price price;
  final Function()? onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 10, 20, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            price.title.trim().capitalLetter(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 5, 0, 10),
                          child: Text(
                            "Длительность ${price.time.getTime()}",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        price.price.toString() + " ₽",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: last
                  ? null
                  : Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
