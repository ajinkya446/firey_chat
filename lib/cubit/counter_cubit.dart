import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterInitial> {
  CounterCubit() : super(CounterInitial(0));

  void increment() => emit(CounterInitial(state.counter + 1));

  void subtract() => emit(CounterInitial(state.counter - 1));
}
