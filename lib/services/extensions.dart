import 'dart:math';

import 'package:look_app/services/answer.dart';

extension StringExtension on String {
  String capitalLetter() {
    if (this.isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${this.substring(1).toLowerCase()}';
  }

  String removeDecoration() {
    return this
        .replaceAll("+", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("-", "")
        .replaceAll(" ", "");
  }

  String removeOther() {
    return this
        .replaceAll("+", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("-", "");
  }
}

extension Lists on List {
  List<dynamic> shuffleList() {
    var random = new Random();

    // Go through all elements.
    for (var i = this.length - 1; i > 0; i--) {
      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = this[i];
      this[i] = this[n];
      this[n] = temp;
    }

    return this;
  }
}

extension Prices on List<Price> {
  String getString() {
    var descr = "";

    for (var item in this) {
      var title = item.title.capitalLetter();
      descr = descr + title + ", ";
    }

    return descr.substring(0, descr.length - 2);
  }

  List<Price> encodeQuotes() {
    for (var item in this) {
      item.title = item.title.replaceAll('"', '');
      item.description = " ";
    }
    return this;
  }

  String getAmount() {
    var amount = 0;
    for (var item in this) {
      amount += item.price;
    }
    return amount.toString();
  }

  String getAllTime() {
    var seconds = 0;
    for (var item in this) {
      seconds += item.time;
    }

    return seconds.getTime();
  }

  int getLength() {
    var seconds = 0;
    for (var item in this) {
      seconds += item.time;
    }
    return seconds;
  }
}

extension IntExtension on int {
  String getExperience() {
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    int years = ((time - this) / 31536000).round();

    if (years == 0) {
      return "Опыт работы меньше года";
    } else if (years == 1) {
      return "Опыт работы 1 год";
    } else if (years == 12 || years == 13 || years == 14) {
      return "Опыт работы $years лет";
    } else if ((years % 10) == 2 || (years % 10) == 3 || (years % 10) == 4) {
      return "Опыт работы $years года";
    }

    return "Опыт работы $years лет";
  }

  String getReviews() {
    if (this == 0) {
      return "Пока нет оценок";
    } else if (this == 1) {
      return "Оставлена 1 оценка";
    } else if ((this % 10) == 2 || (this % 10) == 3 || (this % 10) == 4) {
      return "Оставлено $this оценки";
    }

    return "Оставлено $this оценок";
  }

  String getTime() {
    var h = this ~/ 3600;
    var m = ((this - h * 3600)) ~/ 60;

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    return "$hourLeft:$minuteLeft";
  }
}

extension WorkShifts on List<WorkShift> {
  List<WorkShift> forDate(DateTime date) {
    List<WorkShift> events = [];

    var start = date.millisecondsSinceEpoch ~/ 1000;
    var end = start + 86400;

    for (var item in this) {
      if (item.date > start && item.date < end) {
        events.add(item);
      }
    }

    return events;
  }
}
