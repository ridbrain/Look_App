import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/convert_date.dart';
import 'package:look_app/widgets/empty_banner.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({
    required this.userUid,
  });

  final String userUid;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    NetHandler.getLastNotificationId(widget.userUid).then(
      (id) => PrefsHandler.getInstance().then((prefs) {
        prefs.setLastNotificationId(id);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Уведомления"),
          ),
          FutureBuilder(
            future: NetHandler.getNotifications(widget.userUid),
            builder: (context, AsyncSnapshot<List<Notifications>?> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Shimmer(
                          height: 90,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Shimmer(
                          height: 90,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Shimmer(
                          height: 90,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (snap.hasData && snap.data!.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var notification = snap.data![index];
                      return NotificationCell(
                        notification: notification,
                      );
                    },
                    childCount: snap.data!.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: EmptyBanner(description: "У Вас ещё нет уведомлений."),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class NotificationCell extends StatelessWidget {
  NotificationCell({
    required this.notification,
  });

  final Notifications notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LineIcons.bell,
            color: Colors.blueGrey,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ConvertDate(context).fromUnix(
                    notification.date,
                    "dd MMMM в HH:mm",
                  ),
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
