import 'package:flutter/material.dart';

class Constants {
  static String appStoreId = "1495399647";
  static String channelName = "looklike.beauty";
  static int mapDistance = 50000;

  static BorderRadius radius = BorderRadius.all(
    Radius.circular(13),
  );

  static List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      spreadRadius: 1,
      blurRadius: 7,
    ),
  ];

  String get apiUrl {
    return "https://server.looklike.beauty/users/ver1/scripts/";
  }

  static String slApiKey = "d1d47c33c9a9569c9a404222a98ed08100d2b111";

  static List<Widget> status = [
    Text(
      "Запись в обработке",
      style: const TextStyle(
        color: Colors.deepOrange,
        fontSize: 16,
      ),
    ),
    Text(
      "Запись подтверждена",
      style: const TextStyle(
        color: Colors.teal,
        fontSize: 16,
      ),
    ),
    Text(
      "Оплатите запись",
      style: const TextStyle(
        color: Colors.redAccent,
        fontSize: 16,
      ),
    ),
    Text(
      "Запись оплачена",
      style: const TextStyle(
        color: Colors.blueGrey,
        fontSize: 16,
      ),
    ),
    Text(
      "Запись отменена",
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    ),
  ];

  static String mapStyle = '''
  [
    {
        "featureType": "landscape.man_made",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#f7f1df"
            }
        ]
    },
    {
        "featureType": "landscape.natural",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#d0e3b4"
            }
        ]
    },
    {
        "featureType": "landscape.natural.terrain",
        "elementType": "geometry",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.business",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "poi.medical",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#fbd3da"
            }
        ]
    },
    {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#bde6ab"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "labels",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#ffe15f"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#efd151"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#ffffff"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "black"
            }
        ]
    },
    {
        "featureType": "transit.station.airport",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#cfb2db"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#a2daf2"
            }
        ]
    }
]''';
}
