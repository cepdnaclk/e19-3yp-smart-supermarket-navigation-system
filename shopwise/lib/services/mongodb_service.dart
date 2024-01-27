import 'package:mongo_dart/mongo_dart.dart';

class MongoDB_Service {

  static var db;

static String connectionString = "mongodb+srv://e19210:YQB3qDTT8P4wHQeF@cluster0.cdcjteb.mongodb.net/?retryWrites=true&w=majority";

  static Future<void> initiateConnection() async {
    print("Initiating connection");
     db = await Db.create(connectionString);
    await db.open();
  }

  static Future<void> insertData(
      String collection, Map<String, dynamic> data) async {
    print("Taking collection");

    var currentCollection = db.collection(collection);
    print("currentCollection: ${currentCollection.toString()}" );
    print(await currentCollection.find().toList());
    // print("Inserting data");

    // await currentCollection.insert(data);
  }

  // static Future<void> insertData(String collection, Map<String, dynamic> data) async {
  //   print("Taking collection");
  //   db = await Db.create(connectionString);

  //    var currentCollection = db.collection(collection);
  //   print("Inserting data");
  //   // var db = await Db.create(connectionString);
  //   // await db.open();

  
    
  //   await currentCollection.insert(data);
  // }

  static Future<void> closeCollection() async {
    await db.close();
    print("Close db connection");
  }

  static Future<void> closeConnection() async {
    await db.close();
    print("Close db connection");
  }
}