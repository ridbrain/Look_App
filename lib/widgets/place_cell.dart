import 'package:flutter/material.dart';

class PlaceCell extends StatelessWidget {
  PlaceCell({
    required this.title,
    required this.selected,
    required this.onTap,
    required this.id,
    this.last = false,
  });

  final String title;
  final Function(int id) onTap;
  final int id;
  final bool selected;
  final bool last;

  Widget? getCheck() {
    if (selected) {
      return Icon(
        Icons.check,
        color: Colors.blueGrey[600],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(id),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Align(
                      child: getCheck(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: last
                  ? null
                  : Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.1),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
