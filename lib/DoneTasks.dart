import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'Cubit/Cubit.dart';
import 'Cubit/States.dart';
import 'constants.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToDoCubit,ToDoStates>(
      listener: (context,state){

      },
      builder: (context,state){
        var list = ToDoCubit.getCubit(context).doneTasks;
        return ListView.separated(
            itemBuilder: (context,index){
              return taskWidget(list[index]['id'],list[index]['title'], list[index]['date'], list[index]['time'],context);
            },
            separatorBuilder: (context,index){
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
