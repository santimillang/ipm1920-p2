import 'package:mongo_dart/mongo_dart.dart';

class ExerciseDao {
  find(String name) async {
    Db dataBase = Db("mongodb://10.0.2.2:27017/workouts");
    await dataBase.open();

    var collection = dataBase.collection('exercises');
    var result = await collection.find(where.eq('name', name)).toList();

    dataBase.close();

    if (result.isEmpty) {
      return '';
    }
    return result.first['video'];
  }
}