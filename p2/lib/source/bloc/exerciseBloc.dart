import 'dart:async';

import 'package:p2/source/daos/exerciseDao.dart';

class ExerciseBloc {
  final exerciseDao = ExerciseDao();

  final _exerciseStateController = StreamController<String>();

  final _exerciseEventController = StreamController<String>();

  StreamSink<String> get _inExercises => _exerciseStateController.sink;

  Stream<String> get video => _exerciseStateController.stream;

  Sink<String> get videoEvent => _exerciseEventController.sink;

  ExerciseBloc() {
    _exerciseEventController.stream.listen(_load);
  }

  void _load(String exercise) async {
    _inExercises.add(await exerciseDao.find(exercise));
  }

  void dispose() {
    _exerciseStateController.close();
    _exerciseEventController.close();
  }
}