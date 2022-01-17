import 'dart:async';
import 'dart:convert';

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:look_app/pages/record_price.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/extensions.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/widgets/bill_view.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/convert_date.dart';
import 'package:look_app/widgets/master_places.dart';
import 'package:look_app/widgets/record_prices.dart';
import 'package:look_app/widgets/record_worktimes.dart';
import 'package:look_app/widgets/snack_bar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_check/animated_check.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewRecord extends StatefulWidget {
  NewRecord({
    required this.userUid,
    required this.master,
    required this.prices,
  });

  final String userUid;
  final Master master;
  final List<Price> prices;

  @override
  _NewRecordState createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  PageController controller = PageController();

  List<Price> selectedPrices = [];
  Place? selectedPlace;
  int? selectedShift;
  int? selectedTime;

  var sendRequest = true;
  var error = false;

  void nextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linearToEaseOut,
    );
  }

  void previousPage() {
    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.linearToEaseOut,
    );
  }

  void makeRecord() async {
    if (selectedPrices.isEmpty) {
      StandartSnackBar.show(
        context,
        "Для записи необходимо добавить услуги.",
        SnackBarStatus.warning(),
      );
      return;
    }

    if (selectedPlace == null) {
      StandartSnackBar.show(
        context,
        "Для записи необходимо указать адрес.",
        SnackBarStatus.warning(),
      );
      return;
    }

    if (selectedTime == null) {
      StandartSnackBar.show(
        context,
        "Для записи необходимо выбрать время.",
        SnackBarStatus.warning(),
      );
      return;
    }

    nextPage();

    var answer = await NetHandler.addNewRecord(
      widget.master.masterId.toString(),
      widget.userUid,
      jsonEncode(widget.prices.encodeQuotes()),
      jsonEncode(selectedPlace),
      selectedTime.toString(),
      (selectedTime! + selectedPrices.getLength()).toString(),
      selectedPrices.getAmount(),
    );

    error = answer?.error != 0;

    setState(() {
      sendRequest = false;
    });
  }

  void openSecondPage() {
    if (selectedPrices.isEmpty) {
      StandartSnackBar.show(
        context,
        "До выбора времени необходимо добавить услуги.",
        SnackBarStatus.warning(),
      );
      return;
    }

    if (selectedPlace == null) {
      StandartSnackBar.show(
        context,
        "Для выбора времени необходимо указать адрес.",
        SnackBarStatus.warning(),
      );
      return;
    }

    nextPage();
  }

  Widget getFirstPage() {
    return FirstPage(
      masterId: widget.master.masterId.toString(),
      prices: widget.prices,
      selected: selectedPlace,
      selectPlace: (place) {
        setState(() {
          selectedPlace = place;
        });
      },
      newPrices: (prices) {
        setState(() {
          selectedPrices = prices;
        });
      },
      pressNext: openSecondPage,
    );
  }

  Widget getSecondPage() {
    if (selectedPlace != null) {
      return FutureBuilder(
        future: NetHandler.getWorkShifts(
          widget.master.masterId.toString(),
          selectedPlace!.placeId.toString(),
        ),
        builder: (context, AsyncSnapshot<List<WorkShift>?> snap) {
          if (snap.hasData) {
            return SecondPage(
              masterId: widget.master.masterId.toString(),
              length: selectedPrices.getLength().toString(),
              workshifts: snap.data!,
              selectTime: (time) {
                setState(() {
                  selectedTime = time;
                });
              },
              pressBack: previousPage,
              pressNext: makeRecord,
            );
          }
          return CupertinoActivityIndicator();
        },
      );
    }
    return Container();
  }

  Widget getThirdPage() {
    if (sendRequest) {
      return Center(
        child: CupertinoActivityIndicator(),
      );
    }
    if (error) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Text("Произошла ошибка, попробуйте ещё раз."),
        ),
      );
    }
    if (selectedPlace == null && selectedTime == null) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Text("Произошла ошибка, попробуйте ещё раз."),
        ),
      );
    }
    return ThirdPage(
      master: widget.master,
      prices: selectedPrices,
      time: selectedTime!,
      place: selectedPlace!,
    );
  }

  @override
  void initState() {
    selectedPrices = widget.prices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Новая запись"),
        elevation: 0,
        centerTitle: true,
      ),
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          getFirstPage(),
          getSecondPage(),
          AnimatedSizeAndFade(
            child: getThirdPage(),
          ),
        ],
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  FirstPage({
    required this.masterId,
    required this.prices,
    required this.selected,
    required this.selectPlace,
    required this.newPrices,
    required this.pressNext,
  });

  final String masterId;
  final List<Price> prices;
  final Place? selected;

  final Function(Place place) selectPlace;
  final Function(List<Price> prices) newPrices;
  final Function() pressNext;

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  List<Price> prices = [];

  void selectPrices() async {
    var result = await MainRouter.nextPage(
      context,
      PricePage(
        masterId: widget.masterId,
        count: prices.length,
      ),
    ) as List<Price>;

    for (var item in result) {
      prices.add(item);
    }

    widget.newPrices(prices);
  }

  @override
  void initState() {
    prices = widget.prices;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            RecordPrices(
              prices: prices,
              addPrice: selectPrices,
              delPrice: () => widget.newPrices(prices),
            ),
            MasterPlaces(
              masterId: widget.masterId,
              selected: widget.selected,
              onSelect: widget.selectPlace,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Column(
                children: [
                  DottedLine(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "ИТОГО",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "${prices.getAmount()} ₽",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "ОБЩЕЕ ВРЕМЯ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        prices.getAllTime(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
        Positioned(
          left: 15,
          bottom: MediaQuery.of(context).padding.bottom + 10,
          child: StandartButton(
            label: "Выбрать день и время",
            onTap: widget.pressNext,
          ),
        ),
      ],
    );
  }
}

class SecondPage extends StatefulWidget {
  SecondPage({
    required this.masterId,
    required this.length,
    required this.workshifts,
    required this.pressBack,
    required this.pressNext,
    required this.selectTime,
    this.backLabel = "Назад",
    this.nextLabel = "Записаться",
  });

  final String masterId;
  final String length;
  final List<WorkShift> workshifts;
  final Function(int time) selectTime;

  final String backLabel;
  final String nextLabel;

  final Function() pressBack;
  final Function() pressNext;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  static final _today = DateTime.now();
  static final _firstDay = DateTime(_today.year, _today.month, _today.day - 1);
  static final _lastDay = DateTime(_today.year, _today.month + 3, _today.day);
  late PageController _controller;

  DateTime _focusedDay = ConvertDate.dayBegin();
  DateTime _selectedDay = ConvertDate.dayBegin();

  List<int> times = [];
  var loadingTimes = true;
  int? selectedTime;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      updateTimes();
    }
  }

  void updateTimes() async {
    setState(() {
      times = [];
      loadingTimes = true;
    });

    widget.workshifts.forDate(_selectedDay).forEach((element) async {
      var value = await NetHandler.getWorkTimes(
        widget.masterId,
        element.workshiftId.toString(),
        widget.length,
      );

      value?.forEach((time) {
        times.add(time);
      });

      setState(() {
        times.sort();
        loadingTimes = false;
      });
    });

    if (widget.workshifts.forDate(_selectedDay).isEmpty) {
      setState(() {
        loadingTimes = false;
      });
    }
  }

  @override
  void initState() {
    initializeDateFormatting();
    updateTimes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: GroupLabel(
                    label: ConvertDate(context)
                        .fromDate(_focusedDay, "MMMM")
                        .capitalLetter(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    borderRadius: Constants.radius,
                    child: Icon(
                      LineIcons.arrowCircleLeft,
                      size: 22,
                    ),
                    onTap: () => _controller.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    borderRadius: Constants.radius,
                    child: Icon(
                      LineIcons.arrowCircleRight,
                      size: 22,
                    ),
                    onTap: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            TableCalendar<WorkShift>(
              locale: "ru",
              firstDay: _firstDay,
              lastDay: _lastDay,
              headerVisible: false,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.twoWeeks,
              eventLoader: widget.workshifts.forDate,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: _onDaySelected,
              onCalendarCreated: (controller) {
                _controller = controller;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, items) {
                  if (items.isNotEmpty) {
                    return Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    );
                  }
                },
              ),
              calendarStyle: CalendarStyle(
                todayTextStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.grey[800],
                  shape: BoxShape.circle,
                ),
              ),
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              height: 1,
              color: Colors.grey[200],
            ),
            RecordWorkTimes(
              times: times,
              loading: loadingTimes,
              selected: selectedTime,
              onSelect: (time) {
                widget.selectTime(time);
                setState(() {
                  selectedTime = time;
                });
              },
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
        Positioned(
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).padding.bottom + 10,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: StandartButton(
                  label: widget.backLabel,
                  onTap: widget.pressBack,
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 1,
                child: StandartButton(
                  label: widget.nextLabel,
                  onTap: widget.pressNext,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ThirdPage extends StatefulWidget {
  ThirdPage({
    required this.master,
    required this.prices,
    required this.time,
    required this.place,
  });

  final Master master;
  final List<Price> prices;
  final Place place;
  final int time;

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = new Tween<double>(begin: 0, end: 1).animate(
      new CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOutCirc,
      ),
    );
    Timer(Duration(milliseconds: 500), () {
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        BillView(
          master: widget.master,
          place: widget.place,
          prices: widget.prices,
          begin: widget.time,
          child: AnimatedCheck(
            color: Colors.blueGrey,
            progress: animation,
            size: 150,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        RoundButton(
          icon: LineIcons.thumbsUp,
          label: "Оценить приложение",
          onTap: () => InAppReview.instance.openStoreListing(
            appStoreId: Constants.appStoreId,
          ),
        ),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
