import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class PhotosIcon extends StatefulWidget {
  PhotosIcon({
    required this.userUid,
  });

  final String userUid;

  @override
  _PhotosIconState createState() => _PhotosIconState();
}

class _PhotosIconState extends State<PhotosIcon> {
  var shake = false;

  @override
  void initState() {
    super.initState();
    NetHandler.getLastPhotoId(widget.userUid).then(
      (id) => PrefsHandler.getInstance().then(
        (value) => setState(() {
          shake = id > value.getLastPhotoId();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return shake
        ? ShakeAnimatedWidget(
            enabled: true,
            duration: Duration(milliseconds: 250),
            shakeAngle: Rotation.deg(z: 15),
            curve: Curves.linear,
            child: const Icon(LineIcons.film),
          )
        : const Icon(LineIcons.film);
  }
}
