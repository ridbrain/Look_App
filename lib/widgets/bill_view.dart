import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/extensions.dart';
import 'package:look_app/widgets/convert_date.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class BillView extends StatelessWidget {
  BillView({
    required this.master,
    required this.place,
    required this.prices,
    required this.begin,
    required this.child,
  });

  final Master master;
  final Place place;
  final List<Price> prices;
  final int begin;
  final Widget child;

  String getTime(BuildContext context) {
    var start = ConvertDate(context).fromUnix(
      begin,
      "HH:mm",
    );
    var end = ConvertDate(context).fromUnix(
      begin + prices.getLength(),
      "HH:mm",
    );
    return "$start - $end";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: Constants.shadow,
        borderRadius: Constants.radius,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              master.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              place.address,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
            child: Row(
              children: [
                Container(
                  child: Text(
                    ConvertDate(context).fromUnix(
                      begin,
                      "dd.MM.yyyy",
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  child: Text(
                    getTime(context),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: DottedLine(),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: prices.length * 35,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: prices.length,
              itemBuilder: (context, index) {
                var price = prices[index];
                return Container(
                  height: 35,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          price.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Text(
                          "${price.price} ₽",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: DottedLine(),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "ИТОГО",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "${prices.getAmount()} ₽",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "ОБЩЕЕ ВРЕМЯ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      prices.getAllTime(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
