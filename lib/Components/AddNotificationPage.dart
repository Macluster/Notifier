import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:notifier/Models/NotificationModel.dart';
import 'package:notifier/Services/DatabaseHelper.dart';
import 'package:notifier/Services/Notifications.dart';
import 'package:notifier/main.dart';

class AddNotificationPage extends StatefulWidget {
  @override
  AddNotificationState createState() => AddNotificationState();
}

class AddNotificationState extends State<AddNotificationPage> {
  String SelectedDate = "";
  String SelectedTime = " ";

  void RefreshDataInListBuilder() async {
    DatabaseHelper database = DatabaseHelper.constructor();

    List<NotificationModel> tempList = await database.getData();

    for (int i = 0; i < tempList.length; i++) {
      List dateInList = tempList[i].date.split('-');
      List timeInList = tempList[i].time.split(':');
      print("helooooo000000=" + timeInList[0]);
      if (int.parse(dateInList[0]) == DateTime.now().year) {
        if (int.parse(dateInList[1]) == DateTime.now().month) {
          if (int.parse(dateInList[2]) == DateTime.now().day) {
            if (int.parse(timeInList[0]) == DateTime.now().hour) {
              if (int.parse(timeInList[1]) == DateTime.now().minute) {
              } else if (int.parse(timeInList[1]) > DateTime.now().minute) {
                continue;
              } else {
                database.DeleteRecord(tempList[i].title);
                tempList.removeAt(i);
                i--;
                continue;
              }
            } else if (int.parse(timeInList[0]) > DateTime.now().hour) {
              continue;
            } else {
              database.DeleteRecord(tempList[i].title);
              tempList.removeAt(i);
              i--;
              continue;
            }
          } else if (int.parse(dateInList[2]) > DateTime.now().day) {
            continue;
          } else {
            database.DeleteRecord(tempList[i].title);
            tempList.removeAt(i);
            i--;
            continue;
          }
        } else if (int.parse(dateInList[1]) > DateTime.now().month) {
          continue;
        } else {
          database.DeleteRecord(tempList[i].title);
          tempList.removeAt(i);
          i--;
          continue;
        }
      } else if (int.parse(dateInList[0]) > DateTime.now().year) {
        continue;
      } else {
        database.DeleteRecord(tempList[i].title);
        tempList.removeAt(i);
        i--;
        continue;
      }
    }

    Today_NotificationList = tempList;

    for (int i = 0; i < Today_NotificationList.length; i++) {
      if (Today_NotificationList[i]
              .date
              .compareTo(DateTime.now().toString().split(" ")[0]) !=
          0) {
        Today_NotificationList.removeAt(i);
        print("index=" + i.toString());
        i--;
      }
    }

    Tommarow_NotificationList = await database.getData();

    for (int i = 0; i < Tommarow_NotificationList.length; i++) {
      if (Tommarow_NotificationList[i].date.compareTo(
              DateTime.now().add(Duration(days: 1)).toString().split(" ")[0]) !=
          0) {
        Tommarow_NotificationList.removeAt(i);
        i--;
      }
    }

    setState(() {});
  }

  var TitleController = TextEditingController();

  void DatePicker(BuildContext context) async {
    DateTime CurrDate = DateTime.now();
    final DateTime? Selected = await showDatePicker(
        context: context,
        initialDate: CurrDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025));

    if (Selected != null && Selected != SelectedDate) {
      setState(() {
        SelectedDate = Selected.toString().split(" ")[0];
      });
    }
  }

  void TimePicker(BuildContext context) async {
    TimeOfDay CurrTime = TimeOfDay(hour: 5, minute: 15);
    final TimeOfDay? selected =
        await showTimePicker(context: context, initialTime: CurrTime);

    if (selected != null)
      setState(() {
        SelectedTime =
            selected.hour.toString() + ":" + selected.minute.toString();
      });
  }

  String getTimeIn24HourFormat() {
    String time = "";
    if (SelectedTime != " ") {
      if (int.parse(SelectedTime.split(':')[0]) > 12) {
        time = (int.parse(SelectedTime.split(':')[0]) - 12).toString();
        return time + ":" + SelectedTime.split(':')[1] + " PM";
      } else {
        time = SelectedTime.split(':')[0];
        return time + ":" + SelectedTime.split(':')[1] + " AM";
      }
    }

    return " ";
  }

  String getDateForNotification() {
    String date;

    if (DateTime.now().year.toString() == SelectedDate.split('-')[0] &&
        DateTime.now().month.toString() == SelectedDate.split('-')[1] &&
        DateTime.now().day.toString() == SelectedDate.split('-')[2]) {}

    return DateTime.now().year.toString() +
        "-" +
        DateTime.now().month.toString() +
        "-" +
        DateTime.now().day.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey)]),
      child: Container(
        height: 350,
        width: 250,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 100,
              width: 200,
              child: TextField(
                controller: TitleController,
                decoration: InputDecoration(
                  hintText: "Add Title",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 220,
                  child: Row(
                    children: [
                      Container(
                          width: 110, child: Text("Date:  " + SelectedDate)),
                      SizedBox(
                        width: 30,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          onPressed: () {
                            DatePicker(context);
                          },
                          child: Text(
                            "Set Date",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 220,
                  child: Row(
                    children: [
                      Container(
                        width: 110,
                        child: Text("Time:  " + getTimeIn24HourFormat()),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue)),
                          onPressed: () {
                            TimePicker(context);
                          },
                          child: Text(
                            "Set time",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 45,
            ),
            TextButton(
                onPressed: () async {
                  List SplittedSelectedDate = SelectedDate.split('-');

                  List SplitedSelectedTime = SelectedTime.split(':');
                  /* if (SplitedSelectedTime[0] == "0") {
                    setState(() {
                      SplitedSelectedTime[0] = "12";
                    });
                  } */

                  DateTime date = DateTime(
                      int.parse(SplittedSelectedDate[0]),
                      int.parse(SplittedSelectedDate[1]),
                      int.parse(SplittedSelectedDate[2]),
                      int.parse(SplitedSelectedTime[0]),
                      int.parse(SplitedSelectedTime[1]));

                  int Notificationid = await GenerateID();

                  NotificationPlugin plugin = new NotificationPlugin();
                  plugin.ShowTaskNotification(
                      TitleController.text,
                      date,
                      "On " +
                          getDateForNotification() +
                          " at " +
                          getTimeIn24HourFormat(),
                      Notificationid);
                  DatabaseHelper db = DatabaseHelper.constructor();
                  db.insert(TitleController.text, SelectedDate, SelectedTime,
                      Notificationid);
                  RefreshDataInListBuilder();
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }

  Future<int> GenerateID() async {
    DatabaseHelper database = DatabaseHelper.constructor();
    List<NotificationModel> list = await database.getData();

    int flag = 0;
    int requiredID = 0;

    for (int i = 0; i < 150; i++) {
      for (int j = 0; j < list.length; j++) {
        if (list[j].id == i) {
          flag = 1;
          break;
        }
      }
      if (flag == 1) {
        flag = 0;
      } else {
        requiredID = i;
        break;
      }
    }

    return requiredID;
  }
}
