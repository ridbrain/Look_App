import 'package:look_app/pages/new_record.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/price_cell.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class LastRecord extends StatefulWidget {
  LastRecord({
    required this.uuid,
    required this.master,
  });

  final String uuid;
  final Master master;

  @override
  _LastRecordState createState() => _LastRecordState();
}

class _LastRecordState extends State<LastRecord> {
  final int height = 61;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetHandler.getLastRecord(
        widget.uuid,
        widget.master.masterId.toString(),
      ),
      builder: (context, AsyncSnapshot<Answer?> snap) {
        if (snap.hasData) {
          if (snap.data!.result!.prices!.isNotEmpty) {
            List<Price> prices = snap.data!.result!.prices!;
            return Column(
              children: [
                GroupLabel(
                  label: "Последняя запись",
                  link: "Повторить",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NewRecord(
                          master: widget.master,
                          prices: prices,
                          userUid: widget.uuid,
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: height * prices.length.toDouble(),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: prices.length,
                    itemBuilder: (context, index) {
                      return PriceCell(
                        price: prices[index],
                      );
                    },
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        } else {
          return LoadingLastRecord();
        }
      },
    );
  }
}

class LoadingLastRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Shimmer(
                  height: 14,
                ),
              ),
              Expanded(
                flex: 1,
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
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: Shimmer(
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Shimmer(
                  height: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
