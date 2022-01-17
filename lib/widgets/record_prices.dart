import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/widgets/price_cell.dart';
import 'package:flutter/material.dart';

import 'buttons.dart';

class RecordPrices extends StatefulWidget {
  RecordPrices({
    required this.prices,
    required this.addPrice,
    required this.delPrice,
  });

  final List<Price> prices;
  final Function() addPrice;
  final Function() delPrice;

  @override
  _RecordPricesState createState() => _RecordPricesState();
}

class _RecordPricesState extends State<RecordPrices> {
  final int height = 61;

  Widget getPrices() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: (height * widget.prices.length).toDouble(),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.prices.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              padding: EdgeInsets.symmetric(horizontal: 11),
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: Constants.radius,
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                widget.prices.removeAt(index);
                widget.delPrice();
              });
            },
            child: PriceCell(
              price: widget.prices[index],
              last: index == (widget.prices.length - 1),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GroupLabel(
          label: "Услуги",
        ),
        getPrices(),
        StandartButton(
          label: "Добавить услуги",
          onTap: widget.addPrice,
          grey: true,
        )
      ],
    );
  }
}
