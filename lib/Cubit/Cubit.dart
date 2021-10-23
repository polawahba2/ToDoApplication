import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../AllTasks.dart';
import '../ArchiveTasks.dart';
import '../DoneTasks.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

import 'States.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(InitialState());
  var title = ["All Tasks", "Done Tasks", "Archive Tasks"];
  var my_index = 0;
  var myScreens = [AllTasks(), DoneTasks(), ArchiveTasks()];
  var myDB;
  bool bottomSheeton = false;
  var iconData = Icons.add;
  var tasks = [];
  var newTasks = [];
  var archivedTasks = [];
  var doneTasks = [];
  void createDB() async {
    myDB = await openDatabase('todo.db', version: 1,
        onCreate: (database, version) async {
      print('creating database');
      database
          .execute(
              'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, $colTitle TEXT, $colDate TEXT,$colTime TEXT,$colStatus TEXT)')
          .then((value) {
        print('table created');
        emit(CreateDataBase());
      }).catchError((error) {
        print("error found on DB is : $error");
      });
    }, onOpen: (database) {
      readFromDB(database);
      print("DB is opened");
      emit(OpenDataBase());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCreateDataBase());
    });
  }

  void insertDB(String title, String date, String time) async {
    myDB.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO "$tableName" ("$colTitle","$colDate","$colTime","$colStatus") VALUES("$title","${date}","${time}","new")')
          .then((value) {
        print('row number $value inserted Successfully');
        readFromDB(myDB);
        emit(InsertInDataBase());
      }).catchError((onError) {
        print("error found on DB is : $onError");
      });
    });
  }

  void changeIndex(int index) {
    my_index = index;
    emit(BottomNavigationBarIndexChanged());
  }

  void readFromDB(database) async {
    tasks = await database.rawQuery('select * from "$tableName"');
    print(tasks);

    emit(ReadFromDataBase());
    newTasks = [];
    archivedTasks = [];
    doneTasks = [];
    tasks.forEach((element) {
      if (element['status'] == "new") {
        newTasks.add(element);
      } else if (element['status'] == "archived") {
        archivedTasks.add(element);
      } else {
        doneTasks.add(element);
      }
    });
  }
  // Future<List<Map>> readFromSpicifiDB(database,String condition) async{
  //   var tasks2 = await database.rawQuery('select * from "$tableName" where "$colStatus" = "$condition"');
  //   print(tasks2);
  //   emit(ReadFromDataBase());
  //   return tasks2;
  //
  // }

  void changeBottomSheet(bool isOn) {
    // iconData = icon;
    bottomSheeton = isOn;
    emit(NavBottomSheetChanged());
  }

  static ToDoCubit getCubit(context) {
    return BlocProvider.of(context);
  }

  void updateDataBase(String status, int id) async {
    await myDB.rawUpdate(
        'UPDATE "$tableName" SET status = "$status" WHERE id = "$id"');
    readFromDB(myDB);
    emit(UpdateDataBase());

    print("Row $id Updated Successfully");
  }

  void deleteDataBase(int id) async {
    await myDB.rawDelete('DELETE FROM "$tableName" WHERE id = "$id"');
    readFromDB(myDB);
    emit(DeleteDataBase());
  }
}
