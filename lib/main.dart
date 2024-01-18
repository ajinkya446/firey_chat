import 'package:firey_chat/cubit/counter_cubit.dart';
import 'package:firey_chat/cubit/theme_cubit.dart';
import 'package:firey_chat/home_screen.dart';
import 'package:firey_chat/menus.dart';
import 'package:firey_chat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeCubit>(
        create: (ctx) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeData>(builder: (_, theme) {
          return MaterialApp(debugShowCheckedModeBanner: false, title: 'Flutter Demo', theme: theme, home: LoginScreen());
        }));
  }
}
