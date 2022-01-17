import 'package:look_app/services/answer.dart';
import 'package:look_app/services/network.dart';
import 'package:look_app/widgets/buttons.dart';
import 'package:look_app/widgets/place_cell.dart';
import 'package:look_app/widgets/shimmer.dart';
import 'package:flutter/material.dart';

class MasterPlaces extends StatefulWidget {
  MasterPlaces({
    required this.masterId,
    required this.selected,
    required this.onSelect,
  });

  final String masterId;
  final Place? selected;
  final Function(Place place) onSelect;

  @override
  _MasterPlacesState createState() => _MasterPlacesState();
}

class _MasterPlacesState extends State<MasterPlaces> {
  var first = true;

  Future<List<Place>?> updatePlaces() async {
    var places = await NetHandler.getPlaces(widget.masterId);
    selectPlace(places);
    return places;
  }

  void selectPlace(List<Place>? places) async {
    if (first) {
      await Future.delayed(Duration(milliseconds: 250));

      if (places?.length == 1) {
        setState(() {
          widget.onSelect(places![0]);
        });
      }

      first = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updatePlaces(),
      builder: (context, AsyncSnapshot<List<Place>?> snap) {
        if (snap.hasData) {
          return Column(
            children: [
              GroupLabel(
                label: snap.data!.length == 1 ? "Адрес" : "Адреса",
              ),
              Container(
                height: 1 + (46 * snap.data!.length).toDouble(),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snap.data!.length,
                  itemBuilder: (context, index) {
                    var place = snap.data![index];
                    return PlaceCell(
                      selected: widget.selected?.placeId == place.placeId,
                      title: place.address,
                      last: (index + 1) == snap.data!.length,
                      id: place.placeId,
                      onTap: (id) => setState(() {
                        widget.onSelect(place);
                      }),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              GroupLabel(
                label: "Загрузка",
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Shimmer(
                  height: 20,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
