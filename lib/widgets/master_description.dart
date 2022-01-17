import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class MasterDescriprtion extends StatefulWidget {
  MasterDescriprtion({
    required this.masterId,
  });

  final int masterId;

  @override
  _MasterDescriprtionState createState() => _MasterDescriprtionState();
}

class _MasterDescriprtionState extends State<MasterDescriprtion> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetHandler.getAbout(widget.masterId.toString()),
      builder: (context, AsyncSnapshot<String?> snap) {
        if (snap.hasData) {
          if (snap.data!.length > 5) {
            return Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.fromLTRB(15, 35, 15, 0),
              child: Text(
                snap.data!.trim(),
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            return Container();
          }
        } else {
          return LoadingDescription();
        }
      },
    );
  }
}

class LoadingDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 40, 15, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Shimmer(
                  height: 14,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Shimmer(
                  height: 14,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              )
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Shimmer(
                  height: 14,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
