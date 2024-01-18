import 'package:firey_chat/cubit/counter_cubit.dart';
import 'package:firey_chat/cubit/theme_cubit.dart';
import 'package:firey_chat/menus.dart';
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
          return MaterialApp(debugShowCheckedModeBanner: false, title: 'Flutter Demo', theme: theme, home: const MyHomePage(title: 'Flutter Demo Home Page'));
        }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _drawerSlideController;
  final _animationDuration = initialDelayTime + (staggerTime * menuTitles.length) + buttonDelayTime + buttonTime;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
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

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
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
      title: const Text('Flutter Menu', style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
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
        return FractionalTranslation(
          translation: !valueFlag ? Offset(0.0 + _drawerSlideController.value, 1.0) : Offset(1.0 - _drawerSlideController.value, 0.0),
          child: !valueFlag
              ? BlocBuilder<CounterCubit, CounterInitial>(
                  builder: (context, state) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.counter.toString()),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    BlocProvider.of<CounterCubit>(context).increment();
                                  },
                                  child: const Text("Add")),
                              TextButton(
                                  onPressed: () {
                                    BlocProvider.of<CounterCubit>(context).subtract();
                                  },
                                  child: const Text("Sub"))
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Menu(),
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
