import 'package:firebase_auth/firebase_auth.dart';
import 'package:firey_chat/main.dart';
import 'package:firey_chat/screens/authentication.dart';
import 'package:firey_chat/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  bool _isSigningIn = false;
  final _animationDuration = initialDelayTime + (staggerTime * menuTitles.length) + buttonDelayTime + buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < menuTitles.length; ++i) {
      final startTime = initialDelayTime + (staggerTime * i);
      final endTime = startTime + itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
        : Container(
            color: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildFlutterLogo(),
                _buildContent(),
              ],
            ),
          );
  }

  Widget _buildFlutterLogo() {
    return const Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.2,
        child: FlutterLogo(size: 400),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        /*  const Spacer(),
        _buildGetStartedButton(),*/
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: InkWell(
              onTap: () async {
                if (menuTitles[i] == "Logout") {
                  setState(() {
                    _isSigningIn = true;
                  });
                  await Authentication.signOut(context: context);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyApp()));

                  setState(() {
                    _isSigningIn = false;
                  });
                } else if (menuTitles[i] == "Profile") {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(isProfileEdit: true)));
                }
              },
              child: Text(menuTitles[i], textAlign: TextAlign.left, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      );
    }
    return listItems;
  }
}
