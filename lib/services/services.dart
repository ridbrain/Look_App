import 'package:look_app/services/answer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

Future openMap(BuildContext context, double latitude, double longitude) async {
  if (Theme.of(context).platform == TargetPlatform.iOS) {
    await launch(
      "maps://?q=$latitude,$longitude",
    );
  } else {
    await launch(
      "geo:$latitude,$longitude",
    );
  }
}

class PrefsHandler {
  PrefsHandler(this._preferences);

  final SharedPreferences _preferences;

  final String _userUid = "userUid";
  final String _userName = "userName";
  final String _userPhone = "userPhone";

  final String _review = "reviewRequest";
  final String _lastPhoto = "lastPhoto";
  final String _lastNotification = "lastNotification";

  final String _latitude = "lookLat";
  final String _longitude = "lookLon";

  static Future<PrefsHandler> getInstance() async {
    var shared = await SharedPreferences.getInstance();
    return PrefsHandler(shared);
  }

  bool getReviewStatus() {
    return _preferences.getBool(_review) ?? true;
  }

  void setReviewRequest() {
    _preferences.setBool(_review, false);
  }

  int getLastPhotoId() {
    return _preferences.getInt(_lastPhoto) ?? 0;
  }

  void setLastPhotoId(int id) {
    _preferences.setInt(_lastPhoto, id);
  }

  int getLastNotificationId() {
    return _preferences.getInt(_lastNotification) ?? 0;
  }

  void setLastNotificationId(int id) {
    _preferences.setInt(_lastNotification, id);
  }

  String getUserUid() {
    return _preferences.getString(_userUid) ?? "";
  }

  void setUserUid(String value) {
    _preferences.setString(_userUid, value);
  }

  String getUserName() {
    return _preferences.getString(_userName) ?? "";
  }

  void setUserName(String value) {
    _preferences.setString(_userName, value);
  }

  String getUserPhone() {
    return _preferences.getString(_userPhone) ?? "";
  }

  void setUserPhone(String value) {
    _preferences.setString(_userPhone, value);
  }

  void setUserCoordinate(Position coordinate) {
    _preferences.setDouble(_latitude, coordinate.latitude);
    _preferences.setDouble(_longitude, coordinate.longitude);
  }

  Position? getUserCordinate() {
    var lat = _preferences.getDouble(_latitude);
    var lon = _preferences.getDouble(_longitude);

    if (lat != null && lon != null) {
      return Position(
        longitude: lon,
        latitude: lat,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    return null;
  }
}

class UserProvider extends ChangeNotifier {
  UserProvider(
    this._user,
  );

  User _user;

  User get user => _user;
  bool get hasUser => _user.uid != "";

  static Future<UserProvider> getInstance() async {
    var prefs = await PrefsHandler.getInstance();
    return UserProvider(
      User(
        uid: prefs.getUserUid(),
        name: prefs.getUserName(),
        phone: prefs.getUserPhone(),
      ),
    );
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
    PrefsHandler.getInstance().then((value) {
      value.setUserUid(user.uid);
      value.setUserName(user.name);
      value.setUserPhone(user.phone);
    });
  }

  void setUserUid(String newUid) {
    _user.uid = newUid;
    notifyListeners();
    PrefsHandler.getInstance().then(
      (value) => value.setUserUid(newUid),
    );
  }

  void setUserName(String newName) {
    _user.name = newName;
    notifyListeners();
    PrefsHandler.getInstance().then(
      (value) => value.setUserName(newName),
    );
  }

  void setUserPhone(String newPhone) {
    _user.phone = newPhone;
    notifyListeners();
    PrefsHandler.getInstance().then(
      (value) => value.setUserPhone(newPhone),
    );
  }
}

class CalculateDistance {
  static int radius = 6371210;

  static double computeDelta(degrees) {
    return pi / 180 * radius * cos(deg2rad(degrees));
  }

  static double deg2rad(degrees) {
    return degrees * pi / 180;
  }
}

class Geolocation {
  static Future<Position?> getCurentPosition() async {
    var prefs = await PrefsHandler.getInstance();
    var value = prefs.getUserCordinate();
    var perm = await checkPermission();

    if (value == null) {
      if (!perm) {
        return null;
      }

      var newValue = await Geolocator.getCurrentPosition();
      prefs.setUserCoordinate(newValue);

      return newValue;
    }

    if (perm) {
      Geolocator.getCurrentPosition().then((newValue) {
        prefs.setUserCoordinate(newValue);
      });
    }

    return value;
  }

  static Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}
