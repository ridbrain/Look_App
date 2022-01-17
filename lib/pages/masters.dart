import 'package:look_app/pages/masters_map.dart';
import 'package:look_app/pages/search.dart';
import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/app_bar.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/empty_banner.dart';
import 'package:look_app/widgets/logo.dart';
import 'package:look_app/widgets/masters_table.dart';
import 'package:look_app/widgets/notification_icon.dart';
import 'package:look_app/widgets/place_cell.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class MastersPage extends StatefulWidget {
  MastersPage({
    required this.update,
  });

  final Function() update;

  @override
  _MastersPageState createState() => _MastersPageState();
}

class _MastersPageState extends State<MastersPage> {
  List<Master> masters = [];
  List<String> locations = ["Рядом со мной", "Все города"];
  List<Group> groups = [
    Group(groupId: 0, groupLabel: "Все мастера", masterLabel: ""),
  ];

  var message = "Мастеров по Вашим параметрам к сожалению не найдено";

  var locationId = 0;
  var categoryId = 0;
  var loading = true;

  void updateMasters() async {
    setState(() {
      loading = true;
    });
    if (locationId == 0) {
      masters = getSortMasters(await getCoordinateMasters());
    } else {
      masters = getSortMasters(await getAllMasters());
    }
    setState(() {
      loading = false;
    });
  }

  List<Master> getSortMasters(List<Master> masters) {
    if (categoryId != 0) {
      message = "Мастеров по Вашим параметрам к сожалению не найдено";
      return masters = masters.where((e) => e.groupId == categoryId).toList();
    }
    return masters;
  }

  void updateGroups() async {
    var value = await NetHandler.getGroups();
    setState(() {
      value?.forEach((element) {
        groups.add(element);
      });
    });
  }

  Future<List<Master>> getCoordinateMasters() async {
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

    var value = await NetHandler.getCoordinateMasters(
      (location.latitude - lat).toString(),
      (location.latitude + lat).toString(),
      (location.longitude - lon).toString(),
      (location.longitude + lon).toString(),
    );

    message = "К сожалению, поблизости нет ни одного мастера";
    return value ?? [];
  }

  Future<List<Master>> getAllMasters() async {
    var value = await NetHandler.getMasters();
    message = "Мастеров по Вашим параметрам к сожалению не найдено";
    return value ?? [];
  }

  Widget getMastersTable() {
    if (loading) {
      return LoadingMastersTable();
    } else {
      if (masters.isNotEmpty) {
        return MastersTable(
          masters: masters,
          update: widget.update,
        );
      } else {
        return SliverToBoxAdapter(
          child: EmptyBanner(
            description: message,
          ),
        );
      }
    }
  }

  String getGroupLabel() {
    var label = "";
    groups.forEach((element) {
      if (element.groupId == categoryId) {
        label = element.groupLabel;
      }
    });
    return label;
  }

  @override
  void initState() {
    updateMasters();
    updateGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          StandartAppBar(
            title: LookLogo(height: 20),
            leading: userProvider.hasUser
                ? NotificationIcon(userUid: userProvider.user.uid)
                : SizedBox.shrink(),
            actions: [
              IconButton(
                icon: Icon(LineIcons.mapMarked),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MastersMap();
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(LineIcons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SearchPage();
                      },
                    ),
                  );
                },
              ),
            ],
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
                              locationId = index;
                              updateMasters();
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
                              categoryId = id;
                              updateMasters();
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
          getMastersTable(),
        ],
      ),
    );
  }
}

class MessageNotification extends StatelessWidget {
  final VoidCallback onReply;

  final String message;

  const MessageNotification({
    Key? key,
    required this.onReply,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(child: Image.asset('assets/avatar.png'))),
          title: Text('Boyan'),
          subtitle: Text(message),
          trailing: IconButton(
              icon: Icon(Icons.reply),
              onPressed: () {
                onReply();
              }),
        ),
      ),
    );
  }
}
