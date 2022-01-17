import 'package:look_app/pages/new_record.dart';
import 'package:look_app/pages/user_auth.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/price_cell.dart';
import 'package:flutter/material.dart';
import 'package:look_app/services/extensions.dart';
import 'package:provider/provider.dart';

class MasterPricePage extends StatefulWidget {
  MasterPricePage({
    required this.prices,
    required this.master,
  });

  final List<Price> prices;
  final Master master;

  @override
  _MasterPricePageState createState() => _MasterPricePageState();
}

class _MasterPricePageState extends State<MasterPricePage> {
  void pressRecord(UserProvider provider, Price price) {
    if (!provider.hasUser) {
      MainRouter.fullScreenDialog(
        context,
        UserAuthPage(
          afterClose: true,
        ),
      );
    } else {
      MainRouter.nextPage(
        context,
        NewRecord(
          master: widget.master,
          prices: [price],
          userUid: provider.user.uid,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(
              "Услуги и цены",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PriceCell(
                  price: widget.prices[index],
                  onTap: () => MainRouter.openBottomSheet(
                    context: context,
                    child: PriceDescription(
                      price: widget.prices[index],
                      onTap: () {
                        pressRecord(userProvider, widget.prices[index]);
                      },
                    ),
                  ),
                );
              },
              childCount: widget.prices.length,
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

class PriceDescription extends StatelessWidget {
  PriceDescription({
    required this.price,
    required this.onTap,
  });

  final Price price;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Text(
            price.title.capitalLetter(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: Text(
            price.description ?? "".capitalLetter(),
            textAlign: TextAlign.center,
            maxLines: 6,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
          child: Text(
            "Длительность ${price.time.getTime()}",
            textAlign: TextAlign.center,
            maxLines: 8,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Text(
            "${price.price} ₽",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        StandartButton(
          label: "Записаться",
          onTap: onTap,
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
