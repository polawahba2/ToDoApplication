import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/constants.dart';

import 'BlocObserver.dart';
import 'Home.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        appBarTheme: AppBarTheme(
      centerTitle: true,
      color: kMainColor,
    )),
    home: HomeWedgit(),
  ));
}
