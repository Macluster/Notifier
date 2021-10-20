import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Container(
          height: 70,
          width: 100,
          color: Colors.red,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Image.asset(
                  'assets/Images/trash.png',
                  height: 40,
                  width: 40,
                ),
              ),
            ],
          )),
      alignment: Alignment.centerRight,
    );
  }
}
