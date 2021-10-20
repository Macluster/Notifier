import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifier/Components/ListViewBackground.dart';
import 'package:notifier/Components/NotificationTile.dart';
import 'package:notifier/Services/DatabaseHelper.dart';
import 'package:notifier/Services/Notifications.dart';
import 'package:notifier/main.dart';

class AllNotificationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AllNotificationsPageState();
  }
}

class AllNotificationsPageState extends State<AllNotificationsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetData();
  }

  void GetData() async {
    DatabaseHelper database = DatabaseHelper.constructor();

    All_NotificationList = await database.getData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(
              "All Notifications",
              style: TextStyle(fontSize: 25, fontFamily: 'Share'),
            ),
            Container(
              height: 300,
              width: 330,
              child: ListView.builder(
                  itemCount: All_NotificationList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: new UniqueKey(),
                      child: NotificationTile(
                          All_NotificationList[index].title,
                          All_NotificationList[index].date,
                          All_NotificationList[index].time),
                      background: ListViewBackground(),
                      onDismissed: (DismissDirection direction) {
                        DatabaseHelper db = DatabaseHelper.constructor();

                        db.DeleteRecord(All_NotificationList[index].title);
                        All_NotificationList.removeAt(index);

                        NotificationPlugin plugin = new NotificationPlugin();
                        plugin.cancelTask(All_NotificationList[index].id);
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
