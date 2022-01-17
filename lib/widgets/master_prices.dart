import 'package:look_app/pages/master_price.dart';
import 'package:look_app/pages/new_record.dart';
import 'package:look_app/pages/user_auth.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/price_cell.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Prices extends StatefulWidget {
  Prices({
    required this.master,
  });

  final Master master;

  @override
  _PricesState createState() => _PricesState();
}

class _PricesState extends State<Prices> {
  final int height = 61;

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

    return FutureBuilder(
      future: NetHandler.getPrices(widget.master.masterId.toString()),
      builder: (context, AsyncSnapshot<List<Price>?> snap) {
        if (snap.hasData) {
          return Column(
            children: [
              GroupLabel(
                label: "Услуги",
                link: snap.data!.length.toString(),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MasterPricePage(
                        prices: snap.data!,
                        master: widget.master,
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: snap.data!.length >= 5
                    ? (height * 5).toDouble()
                    : (height * snap.data!.length).toDouble(),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snap.data!.length >= 5 ? 5 : snap.data!.length,
                  itemBuilder: (context, index) {
                    return PriceCell(
                      price: snap.data![index],
                      onTap: () {
                        pressRecord(userProvider, snap.data![index]);
                      },
                    );
                  },
                ),
              ),
              Container(
                child: snap.data!.length == 0
                    ? Text("Мастер еще не добавил услуги")
                    : null,
              ),
            ],
          );
        } else {
          return LoadingPrices();
        }
      },
    );
  }
}

class LoadingPrices extends StatelessWidget {
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
