import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/services/router.dart';
import 'package:look_app/services/services.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/map_navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  MapPage({
    required this.masterId,
  });

  final String masterId;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _controller;

  Set<Marker> markers = <Marker>{};
  List<Place> places = [];

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(55.7522, 37.6156),
    zoom: 9,
  );

  void initMap(GoogleMapController controller) {
    _controller = controller;
    _controller.setMapStyle(Constants.mapStyle);

    getMasterPlaces();
  }

  void getMasterPlaces() async {
    NetHandler.getPlaces(widget.masterId).then((value) {
      places = value ?? [];
      addPoint();
    });
  }

  void addPoint() async {
    if (places.isNotEmpty) {
      move(LatLng(places[0].latitude, places[0].longitude), 11);
    }
    for (var item in places) {
      var marker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(200.0),
        markerId: MarkerId(item.placeNumber),
        position: LatLng(item.latitude, item.longitude),
        onTap: () {
          move(LatLng(item.latitude, item.longitude), 15);
          MainRouter.openBottomSheet(
            context: context,
            height: 280,
            child: PlaceDescription(
              place: item,
            ),
          );
        },
      );

      setState(() {
        markers.add(marker);
      });
    }
  }

  void move(LatLng latLng, double zoom) async {
    var position = CameraPosition(target: latLng, zoom: zoom);
    var update = CameraUpdate.newCameraPosition(position);

    _controller.animateCamera(update);
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
            title: "Адреса обслуживания",
            actionIcon: Icons.star,
            actionOnTap: () {},
          ),
        ],
      ),
    );
  }
}

class PlaceDescription extends StatelessWidget {
  PlaceDescription({
    required this.place,
  });

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 15),
          child: Text(
            place.address,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
          child: "Отсутствует" != place.metro
              ? Text(
                  "${place.togo} ${place.metro}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )
              : null,
        ),
        StandartButton(
          label: "Проложить маршрут",
          onTap: () => openMap(
            context,
            place.latitude,
            place.longitude,
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
