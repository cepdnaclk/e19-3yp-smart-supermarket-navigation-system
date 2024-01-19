import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:shopwise_web/constant.dart';

class MongoDatabase {
  static var db, userCollection;
  static connect() async {
    db = await Db.create(MONGO_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection(COLLECTION_NAME);
  }
}
