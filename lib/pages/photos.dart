import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/src/dismissible_extensions.dart';
import 'package:look_app/pages/photo.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotosPage extends StatelessWidget {
  PhotosPage({
    required this.photos,
    required this.masterName,
  });

  final List<Photo> photos;
  final String masterName;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text(
              "Все примеры",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                  decoration: BoxDecoration(
                    borderRadius: Constants.radius,
                    boxShadow: Constants.shadow,
                  ),
                  child: InkWell(
                    onTap: () => context.pushTransparentRoute(
                      PhotoPage(
                        imgUrl: photos[index].image,
                        name: masterName,
                      ),
                    ),
                    child: Hero(
                      tag: photos[index].image,
                      child: ClipRRect(
                        borderRadius: Constants.radius,
                        child: CachedNetworkImage(
                          imageUrl: photos[index].image,
                          placeholder: (context, url) =>
                              CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: width - 30,
                          height: width - 30,
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: photos.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}
