import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FavoritePageController extends GetxController {
  RxList<dynamic> makeup = RxList<dynamic>();

  var isLoading = false.obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    Database? database;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "db_product";
    database = await openDatabase(path);
    final data = await database.query("makeup");
    for (var item in data) {
      makeup.value.add(item);
    }
    isLoading.value = false;
  }

  Future<void> deleteFromCart(int id, int index) async {
    try {
      Database? database;
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_product";
      database = await openDatabase(path);
      await database.delete("makeup", where: "id = ?", whereArgs: [id]);
      makeup.removeAt(index);
    } catch (e) {
      print("Error deleting from favorite: $e");
    }
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}
