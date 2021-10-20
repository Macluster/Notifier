import 'package:flutter/cupertino.dart';

class NotificationModel {
  String title = "";
  String date = "";
  String time = "";
  int id = 0;

  NotificationModel(this.title, this.date, this.time, this.id);

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return new NotificationModel(
        map['title'], map['date'], map['time'], map['id']);
  }

  Map<String, dynamic> toMap() {
    return {'title': this.title, 'date': this.date, 'time': this.time};
  }
}
