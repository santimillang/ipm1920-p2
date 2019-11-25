import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:p2/source/models/routine.dart';

class WorkoutDao {
  getWorkouts() async {
    Db dataBase = Db("mongodb://10.0.2.2:27017/workouts");
    await dataBase.open();

    var collection = dataBase.collection('workouts');
    var result = await collection.find().toList();

    // await Future.delayed(Duration(seconds: 1));

    List<Routine> workouts = List<Routine>();

    for (var doc in result) {
      workouts.add(Routine(
        doc['name'],
        DateFormat().add_yMMMd().format(doc['_id'].dateTime),
        doc['image'],
        doc['description'][0],
        doc['exercises'],
      ));
    }

    dataBase.close();
    return workouts;
  }
}
