import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/empty_banner.dart';
import 'package:look_app/widgets/photo_cell.dart';
import 'package:look_app/widgets/place_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoSreamPage extends StatefulWidget {
  PhotoSreamPage({
    required this.userUid,
  });

  final String userUid;

  @override
  _PhotoSreamPageState createState() => _PhotoSreamPageState();
}

class _PhotoSreamPageState extends State<PhotoSreamPage> {
  List<String> locations = [
    "Рядом со мной",
    "Все города",
  ];
  List<Group> groups = [
    Group(groupId: 0, groupLabel: "Все мастера", masterLabel: ""),
  ];

  var message = "Мастеров по Вашим параметрам к сожалению не найдено";

  var locationId = 0;
  var categoryId = 0;

  String getGroupLabel() {
    var label = "";
    groups.forEach((element) {
      if (element.groupId == categoryId) {
        label = element.groupLabel;
      }
    });
    return label;
  }

  void updateGroups() async {
    var value = await NetHandler.getGroups();
    setState(() {
      value?.forEach((element) {
        groups.add(element);
      });
    });
  }

  Future<List<Photo>> updatePhotos() async {
    return locationId == 0 ? getCoordinatePhotos() : getAllPhotos();
  }

  List<Photo> getSortPhotos(List<Photo> photos) {
    if (categoryId != 0) {
      message = "Мастеров по Вашим параметрам к сожалению не найдено";
      return photos.where((e) => e.groupId == categoryId).toList();
    }
    return photos;
  }

  Future<List<Photo>> getCoordinatePhotos() async {
    var location = await Geolocation.getCurentPosition();
    if (location == null) {
      if (!await Geolocation.checkPermission()) {
        message =
            "К сожалению, Вы запретили доступ к Вашей геопозиции, для отображения ближайших к Вам мастеров, разрешите доступ в настройках или выберите отображение всех городов.";
        return [];
      }
      message = "К сожалению, мы не смогли определить Ваше местоположение.";
      return [];
    }

    var deltaLat = CalculateDistance.computeDelta(location.latitude);
    var deltaLon = CalculateDistance.computeDelta(location.longitude);

    var lat = Constants.mapDistance / deltaLat;
    var lon = Constants.mapDistance / deltaLon;

    var value = await NetHandler.getCoordinatePhotos(
      (location.latitude - lat).toString(),
      (location.latitude + lat).toString(),
      (location.longitude - lon).toString(),
      (location.longitude + lon).toString(),
    );

    message = "К сожалению, поблизости нет ни одного мастера";
    return value ?? [];
  }

  Future<List<Photo>> getAllPhotos() async {
    var value = await NetHandler.getAllPhotos(widget.userUid);
    message = "Мастеров по Вашим параметрам к сожалению не найдено";
    return value ?? [];
  }

  Widget getPhotosTable() {
    return FutureBuilder(
      future: updatePhotos(),
      builder: (context, AsyncSnapshot<List<Photo>> snap) {
        if (snap.hasData) {
          var photos = getSortPhotos(snap.data!);

          if (photos.isNotEmpty) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PhotoCell(photo: photos[index]);
                },
                childCount: photos.length,
              ),
            );
          }
          return SliverToBoxAdapter(
            child: EmptyBanner(
              description: message,
            ),
          );
        }
        return SliverToBoxAdapter(
          child: Container(
            height: 500,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    updateGroups();
    super.initState();
    NetHandler.getLastPhotoId(widget.userUid).then(
      (id) => PrefsHandler.getInstance().then((value) {
        value.setLastPhotoId(id);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: Text("Примеры работ"),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 45,
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: 15,
                  ),
                  SmallButton(
                    label: locations[locationId],
                    onTap: () => MainRouter.openBottomSheet(
                      height: 150,
                      context: context,
                      child: ListView.builder(
                        itemCount: locations.length,
                        padding: const EdgeInsets.only(top: 5),
                        itemBuilder: (context, index) {
                          return PlaceCell(
                            title: locations[index],
                            selected: locationId == index,
                            id: index,
                            onTap: (id) {
                              setState(() {
                                locationId = index;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                  SmallButton(
                    label: getGroupLabel(),
                    onTap: () => MainRouter.openBottomSheet(
                      context: context,
                      child: ListView.builder(
                        itemCount: groups.length,
                        padding: const EdgeInsets.only(top: 5, bottom: 60),
                        itemBuilder: (context, index) {
                          return PlaceCell(
                            title: groups[index].groupLabel,
                            selected: categoryId == groups[index].groupId,
                            id: groups[index].groupId,
                            onTap: (id) {
                              setState(() {
                                categoryId = id;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
          getPhotosTable(),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}
