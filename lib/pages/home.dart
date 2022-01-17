import 'dart:async';

import 'package:look_app/pages/favorites.dart';
import 'package:look_app/pages/master.dart';
import 'package:look_app/pages/masters.dart';
import 'package:look_app/pages/photo_stream.dart';
import 'package:look_app/pages/records.dart';
import 'package:look_app/pages/user.dart';
import 'package:look_app/pages/user_auth.dart';
import 'package:look_app/services/auth.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/nav_bar.dart';
import 'package:look_app/widgets/photos_icon.dart';
import 'package:look_app/widgets/snack_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_icon_badge/flutter_app_icon_badge.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:smartlook/smartlook.dart';

class HomeRouter extends StatefulWidget {
  @override
  _HomeRouterState createState() => _HomeRouterState();
}

class _HomeRouterState extends State<HomeRouter> {
  var eventChanel = EventChannel(Constants.channelName);

  void loadingMaster(String masterId) {
    NetHandler.getMaster(masterId).then((value) {
      if (value == null) return;
      if (value.error == 0) {
        if (value.result?.master != null) {
          MainRouter.nextPage(
            context,
            MasterPage(master: value.result!.master!),
          );
        }
      } else {
        StandartSnackBar.show(
          context,
          value.message ?? "Ошибка",
          SnackBarStatus.warning(),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    eventChanel.receiveBroadcastStream().listen((event) {
      var id = event.toString().substring(10);
      print(id);
      loadingMaster(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return userProvider.hasUser ? HomeVerification() : HomeGuest();
  }
}

class HomeVerification extends StatefulWidget {
  @override
  _HomeVerificationState createState() => _HomeVerificationState();
}

class _HomeVerificationState extends State<HomeVerification> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    return FutureBuilder(
      future: NetHandler.existUserUid(user.uid),
      builder: (context, AsyncSnapshot<bool?> snap) {
        if (snap.hasData) {
          if (snap.data!) {
            Smartlook.setUserIdentifier(user.uid, {"name": user.name});
            return HomeAuth();
          } else {
            AuthService().signOut(context);
            return HomeGuest();
          }
        } else {
          return Container(color: Colors.white);
        }
      },
    );
  }
}

class HomeAuth extends StatefulWidget {
  @override
  _HomeAuthState createState() => _HomeAuthState();
}

class _HomeAuthState extends State<HomeAuth> {
  var index = 0;

  _getPages(String userUid) {
    return [
      MastersPage(
        update: () => setState(() {}),
      ),
      PhotoSreamPage(
        userUid: userUid,
      ),
      RecordsPage(
        userUid: userUid,
        update: () => setState(() {}),
      ),
      FavoritesPage(
        userUid: userUid,
      ),
      UserPage(),
    ];
  }

  _getBuutons(String userUid) {
    return [
      BottomNavigationBarItem(
        label: "Мастера",
        icon: const Icon(LineIcons.stream),
        activeIcon: Icon(
          LineIcons.stream,
          color: Colors.black,
        ),
      ),
      BottomNavigationBarItem(
        label: "Лента",
        icon: PhotosIcon(
          userUid: userUid,
        ),
        activeIcon: Icon(
          LineIcons.film,
          color: Colors.black,
        ),
      ),
      BottomNavigationBarItem(
        label: "История",
        icon: Stack(
          children: [
            const Icon(LineIcons.history),
            HistoryBadge(userUid: userUid),
          ],
        ),
        activeIcon: Stack(
          children: [
            Icon(
              LineIcons.history,
              color: Colors.black,
            ),
            HistoryBadge(userUid: userUid),
          ],
        ),
      ),
      BottomNavigationBarItem(
        label: "Избранное",
        icon: const Icon(LineIcons.heart),
        activeIcon: Icon(
          LineIcons.heart,
          color: Colors.black,
        ),
      ),
      BottomNavigationBarItem(
        label: "Аккаунт",
        icon: const Icon(LineIcons.userCog),
        activeIcon: Icon(
          LineIcons.userCog,
          color: Colors.black,
        ),
      ),
    ];
  }

  void checkUserName() async {
    PrefsHandler.getInstance().then((value) {
      if (value.getUserName() == "") {
        MainRouter.fullScreenDialog(
          context,
          EditName(
            userUid: value.getUserUid(),
            name: "",
            hide: false,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserName();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      StandartSnackBar.show(
        context,
        message.notification?.body ?? "",
        SnackBarStatus.message(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.white,
      body: _getPages(user.uid)[index],
      bottomNavigationBar: StandartNavBar(
        buttons: _getBuutons(user.uid),
        select: (index) => setState(() {
          this.index = index;
        }),
      ),
    );
  }
}

class HomeGuest extends StatefulWidget {
  @override
  _HomeGuestState createState() => _HomeGuestState();
}

class _HomeGuestState extends State<HomeGuest> {
  var index = 0;

  var pages = [
    MastersPage(
      update: () {},
    ),
    UserAuthPage(),
  ];

  var buttons = [
    BottomNavigationBarItem(
      label: "Мастера",
      icon: const Icon(LineIcons.home),
      activeIcon: Icon(
        LineIcons.home,
        color: Colors.black,
      ),
    ),
    BottomNavigationBarItem(
      label: "Аккаунт",
      icon: const Icon(LineIcons.user),
      activeIcon: Icon(
        LineIcons.user,
        color: Colors.black,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[index],
      bottomNavigationBar: StandartNavBar(
        buttons: buttons,
        select: (index) => setState(() {
          this.index = index;
        }),
      ),
    );
  }
}

class HistoryBadge extends StatefulWidget {
  HistoryBadge({
    required this.userUid,
  });

  final String userUid;

  @override
  _HistoryBadgeState createState() => _HistoryBadgeState();
}

class _HistoryBadgeState extends State<HistoryBadge> {
  late Timer timer;
  var show = false;

  void update() {
    NetHandler.getRecords(widget.userUid, '0').then((value) {
      if (value == null) {
        updateBadge(0);
      } else {
        updateBadge(value.length);
        setState(() {
          show = value.length > 0;
        });
      }
    });
  }

  void updateBadge(int count) {
    if (count == 0) {
      FlutterAppIconBadge.removeBadge();
    } else {
      FlutterAppIconBadge.updateBadge(count);
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (timer) => update());
    update();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: show
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
    );
  }
}
