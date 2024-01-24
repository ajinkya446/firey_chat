import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'constants.dart';
import 'cubit/counter_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final _animationDuration = initialDelayTime + (staggerTime * 3) + buttonDelayTime + buttonTime;

  late AnimationController _staggeredController;
  late Interval _itemSlideIntervals;

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
    final startTime = initialDelayTime + (staggerTime * 3);
    final endTime = startTime + itemSlideTime;
    _itemSlideIntervals = Interval(startTime.inMilliseconds / _animationDuration.inMilliseconds, endTime.inMilliseconds / _animationDuration.inMilliseconds);
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      /*child: Stack(
        fit: StackFit.expand,
        children: [_buildFlutterLogo(), _buildContent()],
      ),*/
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
        _buildListItems(),
        /*  const Spacer(),
        _buildGetStartedButton(),*/
      ],
    );
  }

  Widget _buildListItems() {
    return AnimatedBuilder(
      animation: _staggeredController,
      builder: (context, child) {
        final animationPercent = Curves.easeOut.transform(
          _itemSlideIntervals.transform(_staggeredController.value),
        );
        final opacity = animationPercent;
        final slideDistance = (1.0 - animationPercent) * 150;

        return Opacity(
          opacity: opacity,
          child: Transform.translate(offset: Offset(slideDistance, 0), child: child),
        );
      },
      child: BlocBuilder<CounterCubit, CounterInitial>(
        builder: (context, state) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          );
        },
      ),
    );
  }
}
