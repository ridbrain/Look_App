import 'package:look_app/services/network.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class FavMaster extends StatefulWidget {
  FavMaster({
    required this.masterId,
    required this.userUid,
  });

  final String masterId;
  final String userUid;

  @override
  _FavMasterState createState() => _FavMasterState();
}

class _FavMasterState extends State<FavMaster> {
  _getFavorite() {
    return FutureBuilder(
      future: NetHandler.existFavorite(widget.masterId, widget.userUid),
      builder: (context, AsyncSnapshot<bool?> snap) {
        if (snap.hasData) {
          if (snap.data!) {
            return Icon(
              LineIcons.heartAlt,
            );
          } else {
            return Icon(
              LineIcons.heart,
            );
          }
        }
        return Container();
      },
    );
  }

  _changeFavoriteStatus() {
    NetHandler.changeFavorite(widget.userUid, widget.masterId).then(
      (value) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _getFavorite(),
      onPressed: () {
        _changeFavoriteStatus();
      },
    );
  }
}
