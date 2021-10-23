import 'package:flutter/material.dart';

import 'Cubit/Cubit.dart';

Color kMainColor = Colors.orange;
String tableName = "tasks";
String colTitle = "title";
String colDate = "date";
String colTime = "time";
String colStatus = "status";

Widget taskWidget(int id, String title, String date, String time, context) {
  var myCubit = ToDoCubit.getCubit(context);
  var size = MediaQuery.of(context).size;
  return Dismissible(
    key: Key(id.toString()),
    onDismissed: (direction) {
      myCubit.deleteDataBase(id);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: size.width * 0.09,
            child: Text(
              time,
              style: TextStyle(
                  fontSize: size.width * 0.04, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: size.width * 0.01,
          ),
          Column(
            children: [
              Text(
                title,
                style:
                    TextStyle(fontSize: size.width * 0.08, color: Colors.red),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(date,
                  style: TextStyle(
                      fontSize: size.width * 0.04, color: Colors.blue)),
            ],
          ),
          Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.archive,
                    size: size.width * 0.06,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    myCubit.updateDataBase("archived", id);
                  }),
              IconButton(
                  icon: Icon(Icons.check_box,
                      size: size.width * 0.06, color: Colors.green),
                  onPressed: () {
                    myCubit.updateDataBase("done", id);
                  }),
            ],
          )
        ],
      ),
    ),
  );
}
