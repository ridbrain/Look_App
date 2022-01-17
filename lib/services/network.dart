import 'dart:io';

import 'package:look_app/services/answer.dart';
import 'package:look_app/services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NetHandler {
  static Future<String?> request({
    required String url,
    Map<String, String>? params,
  }) async {
    var response = await http.post(
      Uri.parse(Constants().apiUrl + url),
      body: params,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  static Future<List<Master>?> getMasters() async {
    var address = 'getMasters.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file, minutes: 10);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonMasters(cash).result?.masters;
    } else {
      var data = await request(url: address);
      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonMasters(data).result?.masters;
      } else {
        if (cash != null) {
          return answerFromJsonMasters(cash).result?.masters;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<Master>?> searchMasters(String search) async {
    var address = 'searchMaster.php';

    // await Future.delayed(Duration(seconds: 10));

    var data = await request(url: address, params: {
      "search": search,
    });

    if (data != null) {
      return answerFromJsonMasters(data).result?.masters;
    } else {
      return null;
    }
  }

  static Future<List<String>?> getSearch() async {
    var address = 'getSearch.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file, minutes: 60);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonSearch(cash).result?.search;
    } else {
      var data = await request(url: address);
      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonSearch(data).result?.search;
      } else {
        if (cash != null) {
          return answerFromJsonSearch(cash).result?.search;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<Master>?> getCoordinateMasters(
    String latOne,
    String latTwo,
    String lonOne,
    String lonTwo,
  ) async {
    var address = 'getCoordinateMasters.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file, minutes: 10);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonMasters(cash).result?.masters;
    } else {
      var data = await request(
        url: address,
        params: {
          "lat_one": latOne,
          "lat_two": latTwo,
          "lon_one": lonOne,
          "lon_two": lonTwo,
        },
      );

      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonMasters(data).result?.masters;
      } else {
        if (cash != null) {
          return answerFromJsonMasters(cash).result?.masters;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<Photo>?> getCoordinatePhotos(
    String latOne,
    String latTwo,
    String lonOne,
    String lonTwo,
  ) async {
    var address = 'getCoordinatePhotos.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file, minutes: 60);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonPhotos(cash).result?.photos;
    } else {
      var data = await request(
        url: address,
        params: {
          "lat_one": latOne,
          "lat_two": latTwo,
          "lon_one": lonOne,
          "lon_two": lonTwo,
        },
      );
      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonPhotos(data).result?.photos;
      } else {
        if (cash != null) {
          return answerFromJsonPhotos(cash).result?.photos;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<Master>?> getMastersPlace(String placeNumber) async {
    var address = 'getMastersPlace.php';
    var file = await CashHandler.getFile(address + placeNumber);
    var cash = await CashHandler.getCash(file);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonMasters(cash).result?.masters;
    } else {
      var data = await request(url: address, params: {
        "place_number": placeNumber,
      });
      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonMasters(data).result?.masters;
      } else {
        if (cash != null) {
          return answerFromJsonMasters(cash).result?.masters;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<Master>?> getFavoritesMasters(String userUid) async {
    var address = 'getFavoritesMasters.php';

    var data = await request(url: address, params: {"user_uid": userUid});

    if (data != null) {
      return answerFromJsonMasters(data).result?.masters;
    } else {
      return null;
    }
  }

  static Future<int> getLastPhotoId(String userUid) async {
    var address = 'getLastPhotoId.php';

    var data = await request(url: address, params: {"user_uid": userUid});

    if (data != null) {
      return answerFromJsonNumber(data).result?.number ?? 0;
    } else {
      return 0;
    }
  }

  static Future<int> getLastNotificationId(String userUid) async {
    var address = 'getLastNotificationId.php';

    var data = await request(url: address, params: {"user_uid": userUid});

    if (data != null) {
      return answerFromJsonNumber(data).result?.number ?? 0;
    } else {
      return 0;
    }
  }

  static Future<List<Notifications>?> getNotifications(String userUid) async {
    var address = 'getNotifications.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonNotifications(data).result?.notifications;
    } else {
      return null;
    }
  }

  static Future<String?> getAbout(String masterId) async {
    var address = 'getAboutMaster.php';
    var file = await CashHandler.getFile(address + masterId);
    var cash = await CashHandler.getCash(file);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonText(cash).result?.text;
    } else {
      var data = await request(url: address, params: {"master_id": masterId});
      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonText(data).result?.text;
      } else {
        if (cash != null) {
          return answerFromJsonText(cash).result?.text;
        } else {
          return null;
        }
      }
    }
  }

  static Future<Answer?> getLastRecord(
    String userUid,
    String masterId,
  ) async {
    var address = 'getLastRecord.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "master_id": masterId,
    });

    if (data != null) {
      return answerFromJsonPrices(data);
    } else {
      return null;
    }
  }

  static Future<List<Photo>?> getPhotos(String masterId) async {
    var address = 'getPhotos.php';
    var file = await CashHandler.getFile(address + masterId);
    var cash = await CashHandler.getCash(file);

    // await Future.delayed(Duration(seconds: 3));

    if (cash != null) {
      return answerFromJsonPhotos(cash).result?.photos;
    } else {
      var data = await request(url: address, params: {"master_id": masterId});

      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonPhotos(data).result?.photos;
      } else {
        return null;
      }
    }
  }

  static Future<List<Photo>?> getAllPhotos(String userUid) async {
    var address = 'getAllPhotos.php';

    // await Future.delayed(Duration(seconds: 3));

    var data = await request(url: address, params: {
      "user_uid": userUid,
    });

    if (data != null) {
      return answerFromJsonPhotos(data).result?.photos;
    } else {
      return null;
    }
  }

  static Future<List<Price>?> getPrices(String masterId) async {
    var address = 'getPrices.php';
    var file = await CashHandler.getFile(address + masterId);
    var cash = await CashHandler.getCash(file);

    // await Future.delayed(Duration(seconds: 3));

    if (cash != null) {
      return answerFromJsonPrices(cash).result?.prices;
    } else {
      var data = await request(url: address, params: {
        "master_id": masterId,
      });

      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonPrices(data).result?.prices;
      } else {
        if (cash != null) {
          return answerFromJsonPrices(cash).result?.prices;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<Review>?> getReviews(String mastreId) async {
    var address = 'getReviews.php';

    var data = await request(url: address, params: {
      "master_id": mastreId,
    });

    if (data != null) {
      return answerFromJsonReviews(data).result?.reviews;
    } else {
      return null;
    }
  }

  static Future<String> getWhatsApp(String mastreId) async {
    var address = 'getWhatsApp.php';

    var data = await request(url: address, params: {
      "master_id": mastreId,
    });

    if (data != null) {
      return answerFromJsonText(data).result?.text ?? "";
    } else {
      return "";
    }
  }

  static Future<Answer?> getAuth(
    String phone,
  ) async {
    var address = 'getAuth.php';

    var data = await request(url: address, params: {
      "phone": phone,
    });

    if (data != null) {
      return answerFromJsonText(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> confirmAuth(
    String verification,
    String code,
    String token,
    String os,
  ) async {
    var address = 'confirmAuth.php';

    var data = await request(url: address, params: {
      "verification": verification,
      "code": code,
      "token": token,
      "os": os,
    });

    if (data != null) {
      return answerFromJsonUser(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> confirmFirebaseAuth(
    String idToken,
    String token,
    String os,
  ) async {
    var address = 'confirmFirebaseAuth.php';

    var data = await request(url: address, params: {
      "id_token": idToken,
      "token": token,
      "os": os,
    });

    if (data != null) {
      return answerFromJsonUser(data);
    } else {
      return null;
    }
  }

  static Future<int?> updateUserInfo(
    String userUid,
    String phone,
    String token,
  ) async {
    var address = 'updateUserInfo.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "phone": phone,
      "token": token,
    });

    if (data != null) {
      return answerFromJson(data).error;
    } else {
      return null;
    }
  }

  static Future<List<Place>?> getPlaces(String mastreId) async {
    var address = 'getPlaces.php';
    var file = await CashHandler.getFile(address + mastreId);
    var cash = await CashHandler.getCash(file);

    if (cash != null) {
      return answerFromJsonPlaces(cash).result?.places;
    } else {
      var data = await request(url: address, params: {
        "master_id": mastreId,
      });

      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonPlaces(data).result?.places;
      } else {
        if (cash != null) {
          return answerFromJsonPlaces(cash).result?.places;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<Place>?> getAllPlaces() async {
    var address = 'getAllPlaces.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file);

    if (cash != null) {
      return answerFromJsonPlaces(cash).result?.places;
    } else {
      var data = await request(url: address);

      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonPlaces(data).result?.places;
      } else {
        if (cash != null) {
          return answerFromJsonPlaces(cash).result?.places;
        } else {
          return null;
        }
      }
    }
  }

  static Future<List<WorkShift>?> getWorkShifts(
    String mastreId,
    String placeId,
  ) async {
    var address = 'getWorkShifts.php';

    var data = await request(url: address, params: {
      "master_id": mastreId,
      "place_id": placeId,
    });

    if (data != null) {
      return answerFromJsonWorkShifts(data).result?.workShifts;
    } else {
      return null;
    }
  }

  static Future<List<int>?> getWorkTimes(
    String mastreId,
    String workShiftId,
    String length,
  ) async {
    var address = 'getWorkTimes.php';

    var data = await request(url: address, params: {
      "master_id": mastreId,
      "work_shift_id": workShiftId,
      "length": length,
    });

    if (data != null) {
      return answerFromJsonWorkTimes(data).result?.workTimes;
    } else {
      return null;
    }
  }

  static Future<Answer?> addNewRecord(
    String mastreId,
    String userUid,
    String prices,
    String place,
    String start,
    String end,
    String total,
  ) async {
    var address = 'newRecord.php';

    var data = await request(url: address, params: {
      "master_id": mastreId,
      "user_uid": userUid,
      "prices": prices,
      "place": place,
      "start": start,
      "end": end,
      "total": total,
    });

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<Answer?> changeRecordTime(
    String mastreId,
    String userUid,
    String start,
    String end,
    String recordId,
  ) async {
    var address = 'changeRecordTime.php';

    var data = await request(url: address, params: {
      "master_id": mastreId,
      "user_uid": userUid,
      "start": start,
      "end": end,
      "record_id": recordId,
    });

    if (data != null) {
      return answerFromJson(data);
    } else {
      return null;
    }
  }

  static Future<List<Record>?> getRecords(
    String userUid,
    String status,
  ) async {
    var address = 'getRecords.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "status": status,
    });

    // await Future.delayed(Duration(seconds: 5));

    if (data != null) {
      return answerFromJsonRecords(data).result?.records;
    } else {
      return null;
    }
  }

  static Future<Record?> getRecord(
    String userUid,
    String recordId,
  ) async {
    var address = 'getRecord.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "record_id": recordId,
    });

    if (data != null) {
      return answerFromJsonRecord(data).result?.record;
    } else {
      return null;
    }
  }

  static Future<bool> wishReview(String masterId, String userUid) async {
    var address = 'wishReview.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "master_id": masterId,
    });

    if (data != null) {
      return answerFromJsonExist(data).result?.exist ?? false;
    } else {
      return false;
    }
  }

  static Future<bool?> existFavorite(String masterId, String userUid) async {
    var address = 'existFavorite.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "master_id": masterId,
    });

    if (data != null) {
      return answerFromJsonExist(data).result?.exist;
    } else {
      return null;
    }
  }

  static Future<bool?> existUserUid(String userUid) async {
    var address = 'existUserUid.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
    });

    if (data != null) {
      return answerFromJsonExist(data).result?.exist;
    } else {
      return null;
    }
  }

  static Future<String?> changeFavorite(String userUid, String masterId) async {
    var address = 'changeFavorite.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "master_id": masterId,
    });

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<Review?> getReview(String masterId, String userUid) async {
    var address = 'getReview.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "master_id": masterId,
    });

    // await Future.delayed(Duration(seconds: 10));

    if (data != null) {
      return answerFromJsonReview(data).result?.review;
    } else {
      return null;
    }
  }

  static Future<String?> saveReview(
    String masterId,
    String userUid,
    String message,
    String stars,
  ) async {
    var address = 'saveReview.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "master_id": masterId,
      "message": message,
      "stars": stars,
    });

    await Future.delayed(Duration(seconds: 1));

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<String?> cancelRecord(String userUid, String recordId) async {
    var address = 'cancelRecord.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "record_id": recordId,
    });

    if (data != null) {
      return answerFromJson(data).message;
    } else {
      return null;
    }
  }

  static Future<Answer?> getMaster(String masterId) async {
    var address = 'getMaster.php';

    var data = await request(url: address, params: {
      "master_id": masterId,
    });

    if (data != null) {
      return answerFromJsonMaster(data);
    } else {
      return null;
    }
  }

  static Future<String?> editUserName(String userUid, String name) async {
    var address = 'editUserName.php';

    var data = await request(url: address, params: {
      "user_uid": userUid,
      "name": name,
    });
    if (data != null) {
      return answerFromJsonText(data).result?.text;
    } else {
      return null;
    }
  }

  static Future<List<Group>?> getGroups() async {
    var address = 'getGroups.php';
    var file = await CashHandler.getFile(address);
    var cash = await CashHandler.getCash(file, minutes: 60);

    // await Future.delayed(Duration(seconds: 10));

    if (cash != null) {
      return answerFromJsonGrops(cash).result?.groups;
    } else {
      var data = await request(url: address);
      if (data != null) {
        CashHandler.writeCashe(file, data);
        return answerFromJsonGrops(data).result?.groups;
      } else {
        if (cash != null) {
          return answerFromJsonGrops(cash).result?.groups;
        } else {
          return null;
        }
      }
    }
  }
}

class CashHandler {
  static Future<File> getFile(String file) async {
    var dir = await getTemporaryDirectory();
    return File(dir.path + '/' + file);
  }

  static Future<String?> getCash(File file, {int minutes = 5}) async {
    if (file.existsSync()) {
      var time = DateTime.now().difference(await file.lastModified());
      if (time.inMinutes > minutes) {
        return null;
      } else {
        return file.readAsStringSync();
      }
    } else {
      return null;
    }
  }

  static writeCashe(File file, String data) async {
    file.writeAsStringSync(
      data,
      flush: true,
      mode: FileMode.write,
    );
  }

  static deleteCash() async {
    var dir = await getTemporaryDirectory();
    dir.deleteSync(recursive: true);
  }
}
