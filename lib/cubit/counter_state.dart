part of 'counter_cubit.dart';

@immutable
abstract class CounterState {}

class CounterInitial extends CounterState {
  int counter;

  CounterInitial(this.counter);
}

class CounterLoaded extends CounterState {}

class CounterComplete extends CounterState {}
