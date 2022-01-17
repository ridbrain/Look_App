import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/src/dismissible_extensions.dart';
import 'package:look_app/pages/photo.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoCell extends StatelessWidget {
  PhotoCell({
    required this.photo,
  });

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => context.pushTransparentRoute(
        PhotoPage(
          imgUrl: photo.image,
          name: '',
          masterId: photo.masterId.toString(),
        ),
      ),
      child: Container(
        height: width - 30,
        width: width - 30,
        margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: Hero(
          tag: photo.image,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: Constants.radius,
              boxShadow: Constants.shadow,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: photo.image,
                placeholder: (context, url) => CupertinoActivityIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
                width: width - 30,
                height: width - 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
