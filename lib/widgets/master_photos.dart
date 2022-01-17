import 'package:dismissible_page/src/dismissible_extensions.dart';
import 'package:look_app/pages/photo.dart';
import 'package:look_app/pages/photos.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MasterPhotos extends StatelessWidget {
  MasterPhotos({
    required this.masterId,
    required this.masterName,
  });

  final int masterId;
  final String masterName;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NetHandler.getPhotos(masterId.toString()),
      builder: (context, AsyncSnapshot<List<Photo>?> snap) {
        if (snap.hasData) {
          if (snap.data!.isNotEmpty) {
            return Column(
              children: [
                GroupLabel(
                  label: "Примеры",
                  link: snap.data!.length.toString(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PhotosPage(
                          photos: snap.data!,
                          masterName: masterName,
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: 120,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        width: 110,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                          decoration: BoxDecoration(
                            borderRadius: Constants.radius,
                            boxShadow: Constants.shadow,
                          ),
                          child: InkWell(
                            borderRadius: Constants.radius,
                            onTap: () => context.pushTransparentRoute(
                              PhotoPage(
                                imgUrl: snap.data![index].image,
                                name: masterName,
                              ),
                            ),
                            child: Hero(
                              tag: snap.data![index].image,
                              child: ClipRRect(
                                borderRadius: Constants.radius,
                                child: CachedNetworkImage(
                                  imageUrl: snap.data![index].image,
                                  placeholder: (context, url) =>
                                      CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: snap.data!.length,
                    padding: const EdgeInsets.only(right: 15),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return LoadingPhotos();
        }
      },
    );
  }
}

class LoadingPhotos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Shimmer(
                  height: 14,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Shimmer(
                  height: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 15),
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Shimmer(
                  width: 100,
                  height: 100,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
