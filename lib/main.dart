import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:notifier/Components/ListViewBackground.dart';
import 'package:notifier/Components/NotificationTile.dart';
import 'package:notifier/Models/NotificationModel.dart';
import 'package:notifier/Components/AddNotificationPage.dart';
import 'package:notifier/Screens/AllNotificationPage.dart';
import 'package:notifier/Services/DatabaseHelper.dart';
import 'package:notifier/Services/Notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int AddNotificationFlag = 0;
  String Heading = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    GetStartingData();
  }

  void GetStartingData() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.blueGrey[700],
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 10),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 15,
                        )),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, left: 30),
                      child: Text(
                        Heading,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Share'),
                      )),
                  Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          Text(
                            "Today's  Notificataions",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Share'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 200,
                            child: ListView.builder(
                                itemCount: Today_NotificationList.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: new UniqueKey(),
                                    child: NotificationTile(
                                        Today_NotificationList[index].title,
                                        Today_NotificationList[index].date,
                                        Today_NotificationList[index].time),
                                    background: ListViewBackground(),
                                    onDismissed: (DismissDirection direction) {
                                      DatabaseHelper db =
                                          DatabaseHelper.constructor();

                                      db.DeleteRecord(
                                          Today_NotificationList[index].title);

                                      NotificationPlugin plugin =
                                          new NotificationPlugin();
                                      plugin.cancelTask(
                                          Today_NotificationList[index].id);
                                      Today_NotificationList.removeAt(index);
                                    },
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Tommarows  Notificataions",
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Share'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            child: ListView.builder(
                                itemCount: Tommarow_NotificationList.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: new UniqueKey(),
                                    child: NotificationTile(
                                        Tommarow_NotificationList[index].title,
                                        Tommarow_NotificationList[index].date,
                                        Tommarow_NotificationList[index].time),
                                    background: ListViewBackground(),
                                    onDismissed: (DismissDirection direction) {
                                      DatabaseHelper db =
                                          DatabaseHelper.constructor();

                                      db.DeleteRecord(
                                          Tommarow_NotificationList[index]
                                              .title);
                                      Tommarow_NotificationList.removeAt(index);
                                      NotificationPlugin plugin =
                                          new NotificationPlugin();
                                      plugin.cancelTask(
                                          Tommarow_NotificationList[index].id);
                                    },
                                  );
                                }),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllNotificationsPage()));
                              },
                              child: Text("See all"))
                        ],
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (AddNotificationFlag == 1)
                    Align(
                        alignment: Alignment.center,
                        child: AddNotificationPage()),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.blueGrey[600],
                  height: 50,
                  child: Row(),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(bottom: 30, right: 30),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.all(Radius.circular(32.5))),
                  height: 65,
                  width: 65,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(bottom: 35, right: 32.5),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        if (AddNotificationFlag == 0) {
                          AddNotificationFlag = 1;
                        } else {
                          AddNotificationFlag = 0;
                        }
                      });
                    },
                    child: Text("ADD"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<NotificationModel> Today_NotificationList = [
  /* NotificationModel("Hello1", "2021-10-05", "22:40"),
  NotificationModel("Hello2", "2021-10-05", "22:40"),
  NotificationModel("Hello3", "2021-10-06", "22:40"),
  NotificationModel("Hello4", "2021-10-04", "22:40"),*/
];

List<NotificationModel> Tommarow_NotificationList = [
  /* NotificationModel("Hello1", "2021-10-05", "22:40"),
  NotificationModel("Hello2", "2021-10-05", "22:40"),
  NotificationModel("Hello3", "2021-10-06", "22:40"),
  NotificationModel("Hello4", "2021-10-04", "22:40"),*/
];
List<NotificationModel> All_NotificationList = [];
