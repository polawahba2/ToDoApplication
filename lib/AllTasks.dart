import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Cubit/States.dart';

import 'Cubit/Cubit.dart';
import 'constants.dart';


class AllTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit, ToDoStates>(
      listener: (context, state) {
        if (state is InsertInDataBase) {
          print("insert is called from All tasks screen");
        }
      },
      builder: (context, state) {
        var list = ToDoCubit.getCubit(context).newTasks;
        return ListView.separated(
            itemBuilder: (context, index) {
              return taskWidget(list[index]['id'], list[index]['title'],
                  list[index]['date'], list[index]['time'], context);
            },
            separatorBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              );
            },
            itemCount: list.length);
      },
    );
  }
}
