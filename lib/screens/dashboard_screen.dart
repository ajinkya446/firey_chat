import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import '../cubit/counter_cubit.dart';
import '../cubit/theme_cubit.dart';
import '../home_screen.dart';
import '../menus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _drawerSlideController;
  final _animationDuration = initialDelayTime + (staggerTime * menuTitles.length) + buttonDelayTime + buttonTime;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  bool valueFlag = false;

  @override
  void initState() {
    super.initState();
    _drawerSlideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    if (key.currentState!.isDrawerOpen || valueFlag == true) {
      valueFlag = false;
      _drawerSlideController = AnimationController(vsync: this, duration: _animationDuration)..reverse();
      _drawerSlideController.value == 1.0;
      key.currentState!.closeDrawer();
    } else {
      valueFlag = true;
      key.currentState!.openDrawer();
      _drawerSlideController = AnimationController(vsync: this, duration: _animationDuration)..forward();
      _drawerSlideController.value == 0.0;
    }
    setState(() {});
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0.0,
      title: const Text('Firey Chat', style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic)),
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: AnimatedBuilder(
        animation: _drawerSlideController,
        builder: (context, child) {
          return IconButton(
            onPressed: () {
              _toggleDrawer();
            },
            icon: valueFlag ? const Icon(Icons.clear_all, color: Colors.black) : const Icon(Icons.menu, color: Colors.black),
          );
        },
      ),
    );
  }

  Widget buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return !valueFlag
            ? const HomeScreen()
            : FractionalTranslation(
                translation: Offset(1.0 - _drawerSlideController.value, 0.0),
                child: const Menu(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterCubit>(
        create: (ctx) => CounterCubit(),
        child: SafeArea(
          child: Scaffold(
            key: key,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.brightness_6),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            appBar: buildAppBar(),
            body: buildDrawer(),
          ),
        ));
  }
}
