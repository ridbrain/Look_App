import 'dart:async';

import 'package:look_app/pages/notifications.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class NotificationIcon extends StatefulWidget {
  NotificationIcon({
    required this.userUid,
  });

  final String userUid;

  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  late Timer timer;

  var localId = 0;
  var newId = 0;

  void updateWeb() {
    NetHandler.getLastNotificationId(widget.userUid).then((id) {
      PrefsHandler.getInstance().then((prefs) {
        setState(() {
          localId = prefs.getLastNotificationId();
          newId = id;
        });
      });
    });
  }

  void updateLocal() {
    PrefsHandler.getInstance().then((prefs) {
      prefs.setLastNotificationId(newId);
      setState(() {
        localId = prefs.getLastNotificationId();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateWeb();
    timer = Timer.periodic(
      Duration(seconds: 10),
      (timer) => updateWeb(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        children: [
          Icon(LineIcons.bell),
          Container(
            child: newId > localId
                ? Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Icon(
                      Icons.brightness_1,
                      size: 8.0,
                      color: Colors.red,
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      onPressed: () {
        updateLocal();
        MainRouter.fullScreenDialog(
          context,
          NotificationsPage(userUid: widget.userUid),
        );
      },
    );
  }
}
