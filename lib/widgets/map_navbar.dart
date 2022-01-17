import 'package:look_app/services/constants.dart';
import 'package:flutter/material.dart';

class MapNavBar extends StatefulWidget {
  MapNavBar({
    required this.title,
    required this.actionIcon,
    required this.actionOnTap,
  });

  final String title;
  final IconData actionIcon;
  final Function() actionOnTap;

  @override
  _MapNavBarState createState() => _MapNavBarState();
}

class _MapNavBarState extends State<MapNavBar> {
  Widget getBack(TargetPlatform platform) {
    if (platform == TargetPlatform.iOS) {
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Icon(
          Icons.arrow_back_ios,
        ),
      );
    }
    return Icon(
      Icons.arrow_back,
    );
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;

    return SafeArea(
      child: Container(
        height: kToolbarHeight,
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 3),
              decoration: BoxDecoration(
                borderRadius: Constants.radius,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            Positioned(
              left: 10,
              top: kToolbarHeight / 2 - 22,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(22),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 44,
                    width: 44,
                    child: getBack(platform),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
