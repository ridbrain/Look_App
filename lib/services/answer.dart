// To parse this JSON data, do
//
//     final answer = answerFromJson(jsonString);

import 'dart:convert';

Answer answerFromJson(String str) => Answer.fromJson(json.decode(str));

Answer answerFromJsonExist(String str) =>
    Answer.fromJsonExist(json.decode(str));

Answer answerFromJsonText(String str) => Answer.fromJsonText(json.decode(str));

Answer answerFromJsonMasters(String str) =>
    Answer.fromJsonMasters(json.decode(str));

Answer answerFromJsonPrices(String str) =>
    Answer.fromJsonPrices(json.decode(str));

Answer answerFromJsonPhotos(String str) =>
    Answer.fromJsonPhotos(json.decode(str));

Answer answerFromJsonReviews(String str) =>
    Answer.fromJsonReviews(json.decode(str));

Answer answerFromJsonPlaces(String str) =>
    Answer.fromJsonPlaces(json.decode(str));

Answer answerFromJsonWorkShifts(String str) =>
    Answer.fromJsonWorkShifts(json.decode(str));

Answer answerFromJsonWorkTimes(String str) =>
    Answer.fromJsonWorkTimes(json.decode(str));

Answer answerFromJsonRecords(String str) =>
    Answer.fromJsonRecords(json.decode(str));

Answer answerFromJsonReview(String str) =>
    Answer.fromJsonReview(json.decode(str));

Answer answerFromJsonRecord(String str) =>
    Answer.fromJsonRecord(json.decode(str));

Answer answerFromJsonNumber(String str) =>
    Answer.fromJsonNumber(json.decode(str));

Answer answerFromJsonMaster(String str) =>
    Answer.fromJsonMaster(json.decode(str));

Answer answerFromJsonGrops(String str) =>
    Answer.fromJsonGroups(json.decode(str));

Answer answerFromJsonSearch(String str) =>
    Answer.fromJsonSearch(json.decode(str));

Answer answerFromJsonUser(String str) => Answer.fromJsonUser(json.decode(str));

Answer answerFromJsonNotifications(String str) =>
    Answer.fromJsonNotifications(json.decode(str));

class Answer {
  Answer({
    required this.error,
    this.message,
    this.result,
  });

  int error;
  String? message;
  Result? result;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
      );

  factory Answer.fromJsonExist(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonExist(json["result"]),
      );

  factory Answer.fromJsonText(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonText(json["result"]),
      );

  factory Answer.fromJsonNumber(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonNumber(json["result"]),
      );

  factory Answer.fromJsonMasters(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonMasters(json["result"]),
      );

  factory Answer.fromJsonPrices(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonPrices(json["result"]),
      );

  factory Answer.fromJsonPhotos(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonPhotos(json["result"]),
      );

  factory Answer.fromJsonReviews(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonReviews(json["result"]),
      );

  factory Answer.fromJsonPlaces(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonPlaces(json["result"]),
      );

  factory Answer.fromJsonWorkShifts(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonWorkShifts(json["result"]),
      );

  factory Answer.fromJsonWorkTimes(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonWorkTimes(json["result"]),
      );

  factory Answer.fromJsonRecords(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonRecords(json["result"]),
      );

  factory Answer.fromJsonReview(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonReview(json["result"]),
      );

  factory Answer.fromJsonRecord(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonRecord(json["result"]),
      );

  factory Answer.fromJsonMaster(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonMaster(json["result"]),
      );

  factory Answer.fromJsonUser(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonUser(json["result"]),
      );

  factory Answer.fromJsonGroups(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonGroups(json["result"]),
      );

  factory Answer.fromJsonSearch(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"],
        result: Result.fromJsonSearch(json["result"]),
      );

  factory Answer.fromJsonNotifications(Map<String, dynamic> json) => Answer(
        error: json["error"],
        message: json["message"] ?? "",
        result: Result.fromJsonNotifications(json["result"]),
      );
}

class Result {
  Result({
    this.exist,
    this.text,
    this.masters,
    this.prices,
    this.photos,
    this.reviews,
    this.places,
    this.workShifts,
    this.workTimes,
    this.records,
    this.review,
    this.record,
    this.number,
    this.master,
    this.user,
    this.groups,
    this.search,
    this.notifications,
  });

  bool? exist;
  String? text;
  int? number;

  List<Master>? masters;
  List<Price>? prices;
  List<Photo>? photos;
  List<Review>? reviews;
  List<Place>? places;
  List<WorkShift>? workShifts;
  List<int>? workTimes;
  List<Record>? records;
  List<Group>? groups;
  Review? review;
  Record? record;
  Master? master;
  User? user;
  List<String>? search;
  List<Notifications>? notifications;

  factory Result.fromJsonNotifications(Map<String, dynamic> json) => Result(
        notifications: List<Notifications>.from(
            json["notifications"].map((x) => Notifications.fromJson(x))),
      );

  factory Result.fromJsonSearch(Map<String, dynamic> json) => Result(
        search: List<String>.from(json["search"].map((x) => x)),
      );

  factory Result.fromJsonUser(Map<String, dynamic> json) => Result(
        user: User.fromJson(json["user"] ?? null),
      );

  factory Result.fromJsonMaster(Map<String, dynamic> json) => Result(
        master: json["master"] != null ? Master.fromJson(json["master"]) : null,
      );

  factory Result.fromJsonRecord(Map<String, dynamic> json) => Result(
        record: json["record"] != null ? Record.fromJson(json["record"]) : null,
      );

  factory Result.fromJsonReview(Map<String, dynamic> json) => Result(
        review: json["review"] != null ? Review.fromJson(json["review"]) : null,
      );

  factory Result.fromJsonExist(Map<String, dynamic> json) => Result(
        exist: json["exist"],
      );

  factory Result.fromJsonText(Map<String, dynamic> json) => Result(
        text: json["text"] ?? "",
      );

  factory Result.fromJsonNumber(Map<String, dynamic> json) => Result(
        number: json["number"],
      );

  factory Result.fromJsonRecords(Map<String, dynamic> json) => Result(
        records:
            List<Record>.from(json["records"].map((x) => Record.fromJson(x))),
      );

  factory Result.fromJsonWorkTimes(Map<String, dynamic> json) => Result(
        workTimes: List<int>.from(json["work_times"].map((x) => x)),
      );
  factory Result.fromJsonWorkShifts(Map<String, dynamic> json) => Result(
        workShifts: List<WorkShift>.from(
            json["work_shifts"].map((x) => WorkShift.fromJson(x))),
      );

  factory Result.fromJsonMasters(Map<String, dynamic> json) => Result(
        masters:
            List<Master>.from(json["masters"].map((x) => Master.fromJson(x))),
      );

  factory Result.fromJsonPrices(Map<String, dynamic> json) => Result(
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
      );

  factory Result.fromJsonPhotos(Map<String, dynamic> json) => Result(
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      );

  factory Result.fromJsonReviews(Map<String, dynamic> json) => Result(
        reviews:
            List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      );

  factory Result.fromJsonPlaces(Map<String, dynamic> json) => Result(
        places: List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
      );

  factory Result.fromJsonGroups(Map<String, dynamic> json) => Result(
        groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
      );
}

class Master {
  Master({
    required this.masterId,
    required this.name,
    required this.imageUrl,
    required this.groupId,
    required this.experience,
    required this.reviews,
    required this.rating,
    required this.metro,
  });

  int masterId;
  String name;
  String imageUrl;
  int groupId;
  int experience;
  int reviews;
  double? rating;
  String metro;

  factory Master.fromJson(Map<String, dynamic> json) => Master(
        masterId: json["master_id"],
        name: json["name"],
        imageUrl: json["image_url"],
        groupId: json["group_id"],
        experience: json["experience"],
        reviews: json["reviews"] ?? 0,
        rating: json["rating"] is int
            ? (json['rating'] as int).toDouble()
            : json['rating'],
        metro: json["metro"] ?? "Адрес не указан",
      );
}

class Price {
  Price({
    required this.priceId,
    required this.userId,
    required this.title,
    required this.price,
    required this.description,
    required this.time,
  });

  int priceId;
  int userId;
  String title;
  int price;
  String? description;
  int time;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        priceId: json["price_id"] ?? 0,
        userId: json["user_id"] ?? 0,
        title: json["title"] ?? "",
        price: json["price"] ?? 0,
        description: json["description"].toString(),
        time: json["time"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "price_id": priceId,
        "user_id": userId,
        "title": title,
        "price": price,
        "description": description,
        "time": time,
      };
}

class Photo {
  Photo({
    required this.image,
    this.masterId,
    this.groupId,
  });

  String image;
  int? masterId;
  int? groupId;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        image: json["image"],
        masterId: json["master_id"],
        groupId: json["group_id"],
      );
}

class Review {
  Review({
    this.reviewId,
    this.message,
    this.stars,
    this.date,
    this.name,
  });

  int? reviewId;
  String? message;
  double? stars;
  int? date;
  String? name;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewId: json["review_id"],
        message: json["message"],
        date: json["date"],
        name: json["name"],
        stars: json["stars"] is int
            ? (json['stars'] as int).toDouble()
            : json['stars'],
      );
}

class Place {
  Place({
    required this.placeId,
    required this.placeNumber,
    required this.address,
    required this.metro,
    required this.togo,
    required this.latitude,
    required this.longitude,
  });

  int placeId;
  String placeNumber;
  String address;
  String metro;
  String togo;
  double latitude;
  double longitude;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        placeId: json["place_id"] ?? 0,
        placeNumber: json["place_number"] ?? "",
        address: json["address"].toString(),
        metro: json["metro"].toString(),
        togo: json["togo"].toString(),
        latitude: json["latitude"].toDouble() ?? 0,
        longitude: json["longitude"].toDouble() ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "place_number": placeNumber,
        "address": address,
        "metro": metro,
        "togo": togo,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class WorkShift {
  WorkShift({
    required this.workshiftId,
    required this.date,
  });

  int workshiftId;
  int date;

  factory WorkShift.fromJson(Map<String, dynamic> json) => WorkShift(
        workshiftId: json["workshift_id"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "workshift_id": workshiftId,
        "date": date,
      };
}

class Record {
  Record({
    required this.recordId,
    required this.masterId,
    required this.date,
    required this.status,
    required this.place,
    required this.prices,
    required this.total,
    required this.start,
    required this.end,
    required this.name,
    required this.imageUrl,
    required this.category,
  });

  int recordId;
  int masterId;
  int date;
  int status;
  Place place;
  List<Price> prices;
  int total;
  int start;
  int end;
  String name;
  String imageUrl;
  String category;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        recordId: json["record_id"] ?? 0,
        masterId: json["master_id"] ?? 0,
        date: json["date"] ?? 0,
        status: json["status"] ?? 0,
        place: Place.fromJson(json["place"]),
        prices: List<Price>.from(json["prices"].map((x) => Price.fromJson(x))),
        total: json["total"] ?? 0,
        start: json["start"] ?? 0,
        end: json["end"] ?? 0,
        name: json["name"] ?? "Ошибка",
        imageUrl: json["image_url"] ?? "",
        category: json["category"] ?? "",
      );
}

class User {
  User({
    required this.uid,
    required this.name,
    required this.phone,
  });

  String uid;
  String name;
  String phone;

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        name: json["name"],
        phone: json["phone"].toString(),
      );
}

class Group {
  Group({
    required this.groupId,
    required this.groupLabel,
    required this.masterLabel,
  });

  int groupId;
  String groupLabel;
  String masterLabel;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json["group_id"],
        groupLabel: json["group_label"],
        masterLabel: json["master_label"],
      );

  Map<String, dynamic> toJson() => {
        "group_id": groupId,
        "group_label": groupLabel,
        "master_label": masterLabel,
      };
}

class Notifications {
  Notifications({
    required this.notificationId,
    required this.message,
    required this.date,
  });

  int notificationId;
  String message;
  int date;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        notificationId: json["notification_id"],
        message: json["message"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "message": message,
        "date": date,
      };
}
