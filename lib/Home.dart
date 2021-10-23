import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:sqflite/sqflite.dart';
import 'Cubit/Cubit.dart';
import 'Cubit/States.dart';
import 'constants.dart';

class HomeWedgit extends StatelessWidget {
  var taskTittle = TextEditingController();
  var taskDate = TextEditingController();
  var taskTime = TextEditingController();
  DateTime timeBackPressed = DateTime.now();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ToDoCubit()..createDB(),
      child: BlocConsumer<ToDoCubit, ToDoStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var myCubit = ToDoCubit.getCubit(context);
          return WillPopScope(
            onWillPop: () async {
              final difference = DateTime.now().difference(timeBackPressed);
              final isExitWarning = difference >= Duration(seconds: 2);
              timeBackPressed = DateTime.now();
              if (isExitWarning) {
                Fluttertoast.showToast(
                  msg: 'Press again again to Exit',
                );
                return false;
              } else {
                Fluttertoast.cancel();
                return true;
              }
            },
            child: Scaffold(
              key: scaffoldKey,
              floatingActionButton: FloatingActionButton(
                backgroundColor: kMainColor,
                child: Icon(myCubit.bottomSheeton ? Icons.edit : Icons.add),
                onPressed: () {
                  if (myCubit.bottomSheeton) {
                    if (formKey.currentState!.validate()) {
                      myCubit.changeBottomSheet(false);

                      myCubit.insertDB(
                          taskTittle.text, taskDate.text, taskTime.text);

                      taskTittle.text = "";
                      taskDate.text = "";
                      taskTime.text = "";

                      Navigator.pop(context);
                    }
                  } else {
                    myCubit.changeBottomSheet(true);
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                        Container(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.title),
                                    labelText: 'TaskTitle',
                                  ),
                                  controller: taskTittle,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task title';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.date_range),
                                    labelText: 'TaskDate',
                                  ),
                                  controller: taskDate,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task date';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse("2022-08-07"))
                                        .then((value) {
                                      taskDate.text =
                                          DateFormat.yMMMd().format(value!);
                                      print(value);
                                    });
                                  },
                                ),
                                TextFormField(
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.timer),
                                    labelText: 'TaskTime',
                                  ),
                                  controller: taskTime,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter task time';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      taskTime.text =
                                          value!.format(context).toString();
                                      print(value.format(context).toString());
                                    });
                                  },
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      myCubit.changeBottomSheet(false);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: Colors.orange,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ));
                  }
                },
              ),
              appBar: AppBar(
                title: Text(myCubit.title[myCubit.my_index]),
                automaticallyImplyLeading: false,
                // leading: IconButton(
                //   icon: Icon(Icons.arrow_back),
                //   onPressed: () {
                //     Navigator.pop(context);
                //     myCubit.changeBottomSheet(false);
                //   },
                // ),
              ),
              body: myCubit.myScreens[myCubit.my_index],
              bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: kMainColor,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.all_inbox), label: "All Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.done), label: "Done Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive), label: "Archive Tasks"),
                ],
                onTap: (index) {
                  myCubit.changeIndex(index);
                },
                currentIndex: myCubit.my_index,
                iconSize: size.height * 0.03,
                selectedFontSize: size.height * 0.02,
              ),
            ),
          );
        },
      ),
    );
  }
}
