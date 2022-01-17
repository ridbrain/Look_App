import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/empty_banner.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:look_app/widgets/time_cell.dart';
import 'package:flutter/material.dart';

class RecordWorkTimes extends StatelessWidget {
  RecordWorkTimes({
    required this.times,
    required this.loading,
    required this.onSelect,
    required this.selected,
  });

  final List<int> times;
  final Function(int time) onSelect;
  final int? selected;
  final bool loading;

  Widget getTable(double height) {
    if (loading) {
      return LoadingWorkShifts(
        height: height - 10,
      );
    }
    if (times.isEmpty) {
      return EmptyBanner(
        description: "Времени для записи в этот день к сожалению нет",
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: ((times.length + 1) / 4).round() * height,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemCount: times.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return TimeCell(
            date: times[index],
            selected: selected == times[index],
            onSelect: () {
              onSelect(times[index]);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 60;
    var height = (width / 4 / 2) + 10;

    return Column(
      children: [
        GroupLabel(
          label: "Время",
        ),
        Container(
          height: 10,
        ),
        getTable(height),
      ],
    );
  }
}

class LoadingWorkShifts extends StatelessWidget {
  LoadingWorkShifts({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        children: [
          Expanded(
            child: Shimmer(
              height: height,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Shimmer(
              height: height,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Shimmer(
              height: height,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Shimmer(
              height: height,
            ),
          ),
        ],
      ),
    );
  }
}
