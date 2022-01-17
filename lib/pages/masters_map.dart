import 'dart:async';

import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/bottom_sheet.dart';
import 'package:look_app/widgets/map_navbar.dart';
import 'package:look_app/widgets/masters_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MastersMap extends StatefulWidget {
  @override
  _MastersMapState createState() => _MastersMapState();
}

class _MastersMapState extends State<MastersMap> {
  late GoogleMapController _controller;

  Set<Marker> markers = <Marker>{};
  List<Place> places = [];
  bool accsess = true;
  bool loading = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(55.7522, 37.6156),
    zoom: 9,
  );

  void initMap(GoogleMapController controller) {
    _controller = controller;
    _controller.setMapStyle(Constants.mapStyle);

    getMastersPlaces();
    setLocation();
  }

  void move(LatLng latLng, double zoom) async {
    var position = CameraPosition(target: latLng, zoom: zoom);
    var update = CameraUpdate.newCameraPosition(position);

    _controller.animateCamera(update);
  }

  void addPoint() async {
    setState(() {
      markers.clear();
    });

    for (var item in places) {
      var marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(200.0),
        markerId: MarkerId(item.placeNumber),
        position: LatLng(item.latitude, item.longitude),
        onTap: () {
          if (accsess) {
            MainRouter.openBottomSheet(
              context: context,
              child: MastersList(
                placeNumber: item.placeNumber,
              ),
            );

            accsess = false;

            Timer(Duration(milliseconds: 500), () {
              accsess = true;
            });
          }
        },
      );

      setState(() {
        markers.add(marker);
      });
    }
  }

  void getMastersPlaces() {
    NetHandler.getAllPlaces().then((value) {
      places = value ?? [];
      addPoint();
    });
  }

  void setLocation() async {
    setState(() {
      loading = true;
    });
    var location = await Geolocation.getCurentPosition();
    if (location == null) {
      if (!await Geolocation.checkPermission()) {
        MainRouter.openBottomSheet(
          context: context,
          child: WarningBottom(
            text:
                "К сожалению, Вы запретили доступ к Вашей геопозиции, для отображения ближайших к Вам мастеров, разрешите доступ в настройках или выберите отображение всех городов.",
          ),
        );
      }
      setState(() {
        loading = false;
      });
      return;
    }
    move(LatLng(location.latitude, location.longitude), 10);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            buildingsEnabled: true,
            markers: markers,
            onMapCreated: initMap,
          ),
          MapNavBar(
            title: "Все мастера",
            actionIcon: Icons.info_outline,
            actionOnTap: () {},
          ),
          Center(
            child: loading
                ? Container(
                    width: 60,
                    height: 60,
                    child: CupertinoActivityIndicator(),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: Constants.radius,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class MastersList extends StatefulWidget {
  MastersList({
    required this.placeNumber,
  });

  final String placeNumber;

  @override
  _MastersListState createState() => _MastersListState();
}

class _MastersListState extends State<MastersList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 10,
          ),
        ),
        FutureBuilder(
          future: NetHandler.getMastersPlace(widget.placeNumber),
          builder: (context, AsyncSnapshot<List<Master>?> snap) {
            if (snap.hasData) {
              return MastersTable(
                masters: snap.data!,
                update: () {},
              );
            } else {
              return SliverToBoxAdapter(
                child: Container(),
              );
            }
          },
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom + 10,
          ),
        ),
      ],
    );
  }
}
