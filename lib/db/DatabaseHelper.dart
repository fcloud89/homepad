import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:homepad/model/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static late DatabaseHelper _databaseHelper;
  static late Database _database;

  String cameraTable = 'camera_table';
  String colUid = 'uid';
  String colLoc = 'loc';
  String colUrl = 'url';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'camera.db';
    print(path);
    var carsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return carsDatabase;
  }

  void _createDb(Database db, int newVersion) {
    db.execute(
        'CREATE TABLE $cameraTable($colUid INTEGER PRIMARY KEY AUTOINCREMENT, $colLoc TEXT, $colUrl INTEGER)');
    var file = File('assets/nb/camlist.json');
    List infos = [];
    file.readAsString().then((String contents) {
      infos = json.decode(contents) ?? [];
      List<FileSystemEntity> fileList = Directory('assets/nb').listSync();
      for (Map info in infos) {
        for (FileSystemEntity fileSystemEntity in fileList) {
          // String a = info['uid'].toRadixString(16);
          String uid = info['uid'].toString().padLeft(8, '0');
          if (fileSystemEntity.path.contains(uid)) {
            if (fileSystemEntity.path.endsWith("jpg") ||
                fileSystemEntity.path.endsWith("jpeg") ||
                fileSystemEntity.path.endsWith("png")) {
              info['pre'] = fileSystemEntity.path;
              print("$uid");
              print("$info");
            }
          }
        }
      }
    });
  }

  //  读取数据
  Future<List<Map<String, dynamic>>> getCameraMapList() async {
    Database db = await database;
    var result = await db.query(cameraTable);
    return result;
  }

  //  增加数据
  Future<int> insertCamera(camera car) async {
    Database db = await database;
    var result = await db.insert(cameraTable, car.toMap());
    return result;
  }

  //  刷新数据
  Future<int> updateCamera(camera car) async {
    Database db = await database;
    var result = await db.update(cameraTable, car.toMap(),
        where: '$colUid = ?', whereArgs: [car.uid]);
    return result;
  }

  //  删除数据
  Future<int> deleteCamera(int id) async {
    Database db = await database;
    int result =
        await db.rawDelete('DELETE FROM $cameraTable WHERE $colUid = $id');
    return result;
  }

  //  获取数据条数
  Future<int?> getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $cameraTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // 转化获得 List 类型数据
  Future<List<camera>> getCameraList() async {
    var carMapList = await getCameraMapList();
    int count = carMapList.length;
    List<camera> carList = [];
    for (int i = 0; i < count; i++) {
      carList.add(camera.fromMapObject(carMapList[i]));
    }
    return carList;
  }
}
