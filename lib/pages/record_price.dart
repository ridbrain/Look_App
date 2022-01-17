import 'package:atob_animation/atob_animation.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/price_cell.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class PricePage extends StatefulWidget {
  PricePage({
    required this.masterId,
    required this.count,
  });

  final String masterId;
  final int count;

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<PricePage> {
  List<Price> _selected = [];
  var _count = 0;

  late Offset _startOffset;
  late Offset _endOffset;

  GlobalKey _startkey = GlobalKey();
  GlobalKey _targetkey = GlobalKey();

  _incrementCart() {
    var _overlayEntry = OverlayEntry(
      builder: (_) {
        return AtoBAnimation(
          startPosition: _startOffset,
          endPosition: _endOffset,
          dxCurveAnimation: 0,
          dyCurveAnimation: 0,
          duration: Duration(milliseconds: 400),
          opacity: 0.7,
          child: Container(
            margin: EdgeInsets.only(right: 15),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade600,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  width: 6,
                  height: 6,
                ),
              ),
            ),
          ),
        );
      },
    );
    // Show Overlay
    Overlay.of(context)!.insert(_overlayEntry);
    // wait for the animation to end
    Future.delayed(Duration(milliseconds: 400), () {
      _overlayEntry.remove();
    });
  }

  @override
  void initState() {
    super.initState();
    _count = widget.count;
    WidgetsBinding.instance!.addPostFrameCallback((c) {
      _endOffset = (_targetkey.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
      _startOffset = (_startkey.currentContext!.findRenderObject() as RenderBox)
          .localToGlobal(Offset.zero);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          _selected,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                StandartAppBar(
                  title: Text(
                    "Выберите услуги",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            key: _targetkey,
                            margin: EdgeInsets.only(right: 15),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _count.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                FutureBuilder(
                  future: NetHandler.getPrices(widget.masterId),
                  builder: (context, AsyncSnapshot<List<Price>?> snap) {
                    if (snap.hasData) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var price = snap.data![index];
                            return PriceCell(
                              price: price,
                              onTap: () {
                                _incrementCart();
                                setState(() {
                                  _selected.add(snap.data![index]);
                                  _count++;
                                });
                              },
                            );
                          },
                          childCount: snap.data!.length,
                        ),
                      );
                    } else {
                      return PricesLoading();
                    }
                  },
                ),
              ],
            ),
            Positioned(
              top: 60,
              right: 15,
              child: SafeArea(
                child: Container(
                  key: _startkey,
                  height: 25,
                  width: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PricesLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: 46,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 5,
                      child: Shimmer(
                        height: 15,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 2,
                      child: Shimmer(
                        height: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.grey[100],
                  height: 1,
                ),
              ],
            ),
          );
        },
        childCount: 20,
      ),
    );
  }
}
