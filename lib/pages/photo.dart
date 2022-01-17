import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:look_app/pages/master.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:show_up_animation/show_up_animation.dart';

class PhotoPage extends StatelessWidget {
  PhotoPage({
    required this.imgUrl,
    required this.name,
    this.masterId,
  });

  final String imgUrl;
  final String name;

  final String? masterId;

  Widget getLink() {
    if (masterId == null) {
      return Container();
    } else {
      return FutureBuilder(
        future: NetHandler.getMaster(masterId!),
        builder: (context, AsyncSnapshot<Answer?> snap) {
          if (snap.data?.result?.master != null) {
            return Positioned(
              right: 15,
              bottom: 15 + MediaQuery.of(context).padding.bottom,
              child: ShowUpAnimation(
                animationDuration: Duration(milliseconds: 500),
                child: Container(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: Constants.radius,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 28,
                      ),
                      onTap: () => MainRouter.nextPage(
                        context,
                        MasterPage(master: snap.data!.result!.master!),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      );
    }
  }

  Widget getName(BuildContext context) {
    if (masterId == null) {
      return Positioned(
        left: 15,
        bottom: 15 + MediaQuery.of(context).padding.bottom,
        child: Material(
          color: Colors.transparent,
          child: ShowUpAnimation(
            animationDuration: Duration(milliseconds: 500),
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                shadows: Constants.shadow,
              ),
            ),
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: NetHandler.getMaster(masterId!),
        builder: (context, AsyncSnapshot<Answer?> snap) {
          if (snap.data?.result?.master != null) {
            return Positioned(
              left: 15,
              bottom: 15 + MediaQuery.of(context).padding.bottom,
              child: Material(
                color: Colors.transparent,
                child: ShowUpAnimation(
                  animationDuration: Duration(milliseconds: 500),
                  child: Text(
                    snap.data!.result!.master!.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      shadows: Constants.shadow,
                    ),
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
      child: DismissiblePage(
        onDismiss: () => Navigator.pop(context),
        child: Stack(
          children: [
            Hero(
              tag: imgUrl,
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            getName(context),
            getLink(),
          ],
        ),
      ),
    );
  }
}
