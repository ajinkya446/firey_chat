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
  int index = 0;

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
      title: const Text('Firey Chat', style: TextStyle(color: Colors.white, fontStyle: FontStyle.normal)),
      backgroundColor: Color(0xffb3b3ff),
      automaticallyImplyLeading: false,
      /*leading: AnimatedBuilder(
        animation: _drawerSlideController,
        builder: (context, child) {
          return InkWell(
            onTap: () {
              _toggleDrawer();
            },
            icon: valueFlag ? const Icon(Icons.clear_all, color: Colors.black) : const Icon(Icons.menu, color: Colors.black),
          );
        },
      ),*/
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
            /*floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.brightness_6),
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),*/
            appBar: buildAppBar(),
            body: buildDrawer(),
            bottomNavigationBar: Container(
              color: const Color(0xffb3b3ff),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                InkWell(
                  child: SizedBox(
                      height: 42,
                      child: Column(
                        children: [
                          Icon(
                            size: 28,
                            Icons.call,
                            color: index == 1 ? const Color(0xffffffff) : const Color(0xff3333ff),
                          ),
                          Text('Calls', style: TextStyle(color: index == 1 ? const Color(0xffffffff) : const Color(0xff3333ff), fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      )),
                  onTap: () {
                    closeDrawer();
                    setState(() => index = 1);
                  },
                ),
                InkWell(
                  child: SizedBox(
                    height: 42,
                    child: Column(
                      children: [
                        Icon(
                          size: 28,
                          Icons.message_outlined,
                          color: index == 2 ? const Color(0xffffffff) : const Color(0xff3333ff),
                        ),
                        Text('Messages', style: TextStyle(color: index == 2 ? const Color(0xffffffff) : const Color(0xff3333ff), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  onTap: () {
                    closeDrawer();
                    setState(() => index = 2);
                  },
                ),
                InkWell(
                  child: SizedBox(
                    height: 42,
                    child: Column(
                      children: [
                        Icon(
                          size: 28,
                          Icons.groups,
                          color: index == 3 ? const Color(0xffffffff) : const Color(0xff3333ff),
                        ),
                        Text('Community', style: TextStyle(color: index == 3 ? const Color(0xffffffff) : const Color(0xff3333ff), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  onTap: () {
                    closeDrawer();
                    setState(() => index = 3);
                  },
                ),
                InkWell(
                  child: SizedBox(
                    height: 42,
                    child: Column(
                      children: [
                        Icon(
                          size: 28,
                          Icons.person,
                          color: index == 4 ? const Color(0xffffffff) : const Color(0xff3333ff),
                        ),
                        Text('Profile', style: TextStyle(color: index == 4 ? const Color(0xffffffff) : const Color(0xff3333ff), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  onTap: () {
                    closeDrawer();
                    setState(() => index = 4);
                  },
                ),
                InkWell(
                  child: SizedBox(
                    height: 42,
                    child: Column(
                      children: [
                        AnimatedBuilder(
                            animation: _drawerSlideController,
                            builder: (context, child) {
                              return Icon(
                                size: 28,
                                Icons.settings,
                                color: index == 5 ? const Color(0xffffffff) : const Color(0xff3333ff),
                              );
                            }),
                        Text('Settings', style: TextStyle(color: index == 5 ? const Color(0xffffffff) : const Color(0xff3333ff), fontSize: 11, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  onTap: () {
                    _toggleDrawer();
                    setState(() => index = 5);
                  },
                ),
              ]),
            ),
          ),
        ));
  }

  void closeDrawer() {
    if (key.currentState!.isDrawerOpen || valueFlag == true) {
      valueFlag = false;
      _drawerSlideController = AnimationController(vsync: this, duration: _animationDuration)..reverse();
      _drawerSlideController.value == 1.0;
      key.currentState!.closeDrawer();
    }
  }
}
