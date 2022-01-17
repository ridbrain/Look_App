import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/empty_banner.dart';
import 'package:look_app/widgets/masters_table.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({
    required this.userUid,
  });

  final String userUid;

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Master> masters = [];
  var loading = true;

  void updateFavorites() {
    NetHandler.getFavoritesMasters(widget.userUid).then((value) {
      setState(() {
        loading = false;
        masters = value ?? [];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        StandartAppBar(
          title: Text("Избранное"),
        ),
        MastersTable(
          masters: masters,
          update: () => updateFavorites(),
        ),
        SliverToBoxAdapter(
          child: !loading && masters.length == 0
              ? EmptyBanner(
                  description: "Ещё нет избранных мастеров",
                )
              : Container(),
        ),
      ],
    );
  }
}
