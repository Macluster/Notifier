import 'package:flutter/material.dart';
import 'package:notifier/Services/DatabaseHelper.dart';

class NotificationTile extends StatelessWidget {
  String title = "";
  String date = "";
  String time = "";

  NotificationTile(this.title, this.date, this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 70,
      width: 500,
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(title),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/Images/calendar.png',
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(date),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/Images/clock.png',
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(width: 10),
                  Text(time)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
