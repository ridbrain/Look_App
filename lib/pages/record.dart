import 'package:look_app/pages/new_record.dart';
import 'package:look_app/pages/review.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/extensions.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/bill_view.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/convert_date.dart';
import 'package:look_app/widgets/snack_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class FullRecord extends StatefulWidget {
  FullRecord({
    required this.userUid,
    required this.master,
    required this.record,
  });

  final String userUid;
  final Master master;
  final Record record;

  @override
  _FullRecordState createState() => _FullRecordState();
}

class _FullRecordState extends State<FullRecord> {
  late Record record;

  void updateRecord() {
    NetHandler.getRecord(
      widget.userUid,
      widget.record.recordId.toString(),
    ).then(
      (value) => setState(() {
        record = value ?? widget.record;
      }),
    );
  }

  Widget getSecond(String userUid) {
    if (record.status < 2) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.random,
          label: "Перенести",
          onTap: () => MainRouter.fullScreenDialog(
            context,
            ChangeTime(
              masterId: widget.master.masterId.toString(),
              placeId: widget.record.place.placeId.toString(),
              length: widget.record.prices.getLength().toString(),
              recordId: widget.record.recordId.toString(),
              userUid: widget.userUid,
              done: updateRecord,
            ),
          ),
        ),
      );
    }
    return Expanded(
      flex: 1,
      child: RoundButton(
        icon: LineIcons.syncIcon,
        label: "Повторить",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return NewRecord(
                  prices: record.prices,
                  userUid: widget.userUid,
                  master: widget.master,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget getThird() {
    if (record.status < 2) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.frowningFace,
          label: "Отменить",
          onTap: () {
            NetHandler.cancelRecord(
              widget.userUid,
              record.recordId.toString(),
            ).then((value) {
              if (value == null) return;
              updateRecord();
              StandartSnackBar.show(
                context,
                value,
                SnackBarStatus.message(),
              );
            });
          },
        ),
      );
    }
    if (record.status == 2) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.rubleSign,
          label: "Оплатить",
          onTap: () {
            NetHandler.getWhatsApp(
              record.masterId.toString(),
            ).then((value) {
              Clipboard.setData(
                ClipboardData(
                  text: value.substring(value.length - 11),
                ),
              );
              StandartSnackBar.show(
                context,
                'Номер телефона для быстрого перевода скопирован. Откройте любой клиент банк и совершите перевод',
                SnackBarStatus.message(),
              );
            });
          },
        ),
      );
    }
    if (record.status > 2) {
      return Expanded(
        flex: 1,
        child: RoundButton(
          icon: LineIcons.thumbsUp,
          label: "Оценить",
          onTap: () {
            NetHandler.wishReview(
              record.masterId.toString(),
              widget.userUid,
            ).then((value) {
              if (value) {
                MainRouter.nextPage(
                  context,
                  ReviewPage(
                    masterId: record.masterId.toString(),
                    userUid: widget.userUid,
                  ),
                );
              } else {
                StandartSnackBar.show(
                  context,
                  'Для оценки работы мастера, нужно иметь хотя бы одну выполненную заявку.',
                  SnackBarStatus.warning(),
                );
              }
            });
          },
        ),
      );
    }
    return SizedBox.shrink();
  }

  @override
  void initState() {
    super.initState();
    record = widget.record;
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      updateRecord();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(
              ConvertDate(context)
                  .fromUnix(
                    record.start,
                    "EEEE",
                  )
                  .capitalLetter(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.navigation_outlined),
                onPressed: () {
                  openMap(
                    context,
                    record.place.latitude,
                    record.place.longitude,
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: BillView(
              master: widget.master,
              place: record.place,
              prices: record.prices,
              begin: record.start,
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    DottedLine(),
                    SizedBox(
                      height: 15,
                    ),
                    Constants.status[record.status],
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 50),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: RoundButton(
                          icon: LineIcons.whatSApp,
                          label: "Написать",
                          onTap: () async {
                            var success = await launch(
                              await NetHandler.getWhatsApp(
                                record.masterId.toString(),
                              ),
                            );
                            if (!success) {
                              StandartSnackBar.show(
                                context,
                                'Для связи с мастером установите WhatsApp',
                                SnackBarStatus.warning(),
                              );
                            }
                          },
                        ),
                      ),
                      getSecond(widget.userUid),
                      getThird(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeTime extends StatefulWidget {
  ChangeTime({
    required this.userUid,
    required this.masterId,
    required this.recordId,
    required this.placeId,
    required this.length,
    required this.done,
  });

  final String userUid;
  final String masterId;
  final String recordId;
  final String placeId;
  final String length;

  final Function() done;

  @override
  _ChangeTimeState createState() => _ChangeTimeState();
}

class _ChangeTimeState extends State<ChangeTime> with TickerProviderStateMixin {
  List<WorkShift> workshifts = [];
  int? selectedTime;

  var loading = true;
  var success = false;

  Widget getPage() {
    if (loading) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    if (success) {
      return Center(
        child: Text("Готово"),
      );
    }

    return SecondPage(
      masterId: widget.masterId,
      length: widget.length,
      workshifts: workshifts,
      pressBack: () => Navigator.pop(context),
      pressNext: changeTime,
      selectTime: (time) {
        setState(() {
          selectedTime = time;
        });
      },
      backLabel: "Отменить",
      nextLabel: "Перенести",
    );
  }

  void updateShifts() async {
    var shifts = await NetHandler.getWorkShifts(
      widget.masterId,
      widget.placeId,
    );

    setState(() {
      workshifts = shifts ?? [];
      loading = false;
    });
  }

  void changeTime() async {
    if (selectedTime == null) {
      StandartSnackBar.show(
        context,
        "Выбирете время",
        SnackBarStatus.warning(),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    var answer = await NetHandler.changeRecordTime(
      widget.masterId,
      widget.userUid,
      selectedTime.toString(),
      (selectedTime! + int.parse(widget.length)).toString(),
      widget.recordId,
    );

    if (answer?.error == 0) {
      StandartSnackBar.show(
        context,
        "Заявка перенесена успешно",
        SnackBarStatus.message(),
      );
      widget.done();
      Navigator.pop(context);
    } else {
      StandartSnackBar.show(
        context,
        "Произошла ошибка",
        SnackBarStatus.warning(),
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    updateShifts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Перенос записи"),
        elevation: 0,
      ),
      body: getPage(),
    );
  }
}
