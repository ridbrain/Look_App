import 'package:look_app/pages/record.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/empty_banner.dart';
import 'package:look_app/widgets/records_table.dart';
import 'package:look_app/widgets/snack_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class RecordsPage extends StatefulWidget {
  RecordsPage({
    required this.userUid,
    required this.update,
  });

  final String userUid;
  final Function() update;

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  List<Record> records = [];
  var loading = false;
  var status = 0;

  void loadingList() {
    setState(() {
      loading = true;
      records = [];
    });
    NetHandler.getRecords(widget.userUid, status.toString()).then((value) {
      setState(() {
        loading = false;
        records = value ?? [];
      });
    });
  }

  void updateList() {
    NetHandler.getRecords(widget.userUid, status.toString()).then((value) {
      setState(() {
        records = value ?? [];
      });
    });
  }

  void reviewRequest() {
    if (records.length > 0) {
      PrefsHandler.getInstance().then((prefs) async {
        if (prefs.getReviewStatus()) {
          final InAppReview inAppReview = InAppReview.instance;
          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
            prefs.setReviewRequest();
          }
        }
      });
    }
  }

  Widget getPage() {
    if (loading) {
      return SliverToBoxAdapter(
        child: Column(
          children: [
            LoadingRecordCell(),
            LoadingRecordCell(),
          ],
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return RecordCardView(
              record: records[index],
              onTap: () {
                NetHandler.getMaster(records[index].masterId.toString())
                    .then((value) {
                  if (value?.error == 1) {
                    StandartSnackBar.show(
                      context,
                      value!.message!,
                      SnackBarStatus.warning(),
                    );
                    return;
                  }
                  MainRouter.nextPage(
                    context,
                    FullRecord(
                      userUid: widget.userUid,
                      master: value!.result!.master!,
                      record: records[index],
                    ),
                  ).then((value) {
                    reviewRequest();
                    if (status == 0) {
                      updateList();
                    }
                  });
                });
              },
            );
          },
          childCount: records.length,
        ),
      );
    }
  }

  Widget getBanner() {
    if (records.isEmpty && !loading) {
      return SliverToBoxAdapter(
        child: EmptyBanner(description: "Записей ещё нет"),
      );
    } else {
      return SliverToBoxAdapter(
        child: Container(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadingList();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (status == 0) {
        updateList();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(
              "Записи",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 45,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: ListView.builder(
                padding: const EdgeInsets.only(right: 15),
                scrollDirection: Axis.horizontal,
                itemCount: RecordCategory.all.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: SmallButton(
                      label: RecordCategory.all[index].title,
                      deselect: status != index,
                      onTap: () => setState(() {
                        status = RecordCategory.all[index].id;
                        updateList();
                      }),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
            ),
          ),
          getPage(),
          getBanner(),
        ],
      ),
    );
  }
}

class RecordCategory {
  String title;
  int id;

  RecordCategory({
    required this.title,
    required this.id,
  });

  static List<RecordCategory> all = [
    RecordCategory(title: "Активные", id: 0),
    RecordCategory(title: "Прошедшие", id: 1),
    RecordCategory(title: "Отменённые", id: 2),
  ];
}
