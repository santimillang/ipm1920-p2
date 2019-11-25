import 'dart:async';

import 'package:p2/source/daos/workoutDao.dart';
import 'package:p2/source/models/routine.dart';

class RoutineBloc {
  final workoutDao = WorkoutDao();

  final _workoutsStateController = StreamController<List<Routine>>();

  final _workoutsEventController = StreamController<int>();

  StreamSink<List<Routine>> get _inWorkouts => _workoutsStateController.sink;

  Stream<List<Routine>> get workouts => _workoutsStateController.stream;

  Sink<int> get workoutsEvent => _workoutsEventController.sink;

  RoutineBloc() {
    _workoutsEventController.stream.listen(_load);
  }

  void _load(int event) async {
    List<Routine> routines = await workoutDao.getWorkouts();
    _inWorkouts.add(routines);
  }

  void dispose() {
    _workoutsStateController.close();
    _workoutsEventController.close();
  }


}
