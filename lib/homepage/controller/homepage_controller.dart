import 'dart:convert';
import 'dart:io';

import 'package:flutter_cart_sqflite/model/product_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class HomepageController extends GetxController {
  RxList<ProductModel> data = new RxList<ProductModel>();
  RxList<RxBool> isCart = RxList<RxBool>();
  var isLoading = false.obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    var headers = {"Accept": "application/json"};

    var response = await http.get(
        Uri.parse(
            "https://makeup-api.herokuapp.com/api/v1/products.json?brand=l'oreal"),
        headers: headers);
    List<dynamic> jsonData = json.decode(response.body);
    data.value = jsonData.map((e) => ProductModel.fromJson(e)).toList();
    checkCart();
    isLoading.value = false;
  }

  Future<void> initDatabase() async {
    Database? database;
    String db_name = "db_product";
    int db_version = 1;

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + db_name;

    database = await openDatabase(path, version: db_version,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS makeup (
        id INTEGER PRIMARY KEY,
        imageLink TEXT,
        title TEXT,
        price TEXT,
      )
    ''');
    });
  }
  
  Future<void> addToCart({
    required String imageLink,
    required String title,
    required String price,
    required int id,
  }) async {
    Database? database;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "db_product";
    database = await openDatabase(path);

    await database.insert("makeup", {
      "id": id,
      "imageLink": imageLink,
      "title": title,
      "price": price,
    },
        conflictAlgorithm: ConflictAlgorithm.replace);
    Get.snackbar(
      'Added to Cart',
      '$title has been added to your shopping cart!',
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 1),
    );
  }

  Future<void> checkCart() async {
    Database? database;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "db_product";
    database = await openDatabase(path);

    isCart.value = List.generate(data.length, (index) => false.obs);

    for (int i = 0; i < data.length; i++) {
      List<Map<String, dynamic>> result = await database.query(
        "makeup",
        where: 'id = ?',
        whereArgs: [data[i].id],
      );
      bool cart = result.isNotEmpty;
      print(cart);
      isCart[i].value = cart;
    }
  }

  Future<void> deleteFromCart(int id) async {
    Database? database;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "db_product";
    database = await openDatabase(path);

    await database.delete("makeup", where: "id = ?", whereArgs: [id]);
  }

  @override
  void onInit() {
    initDatabase();
    fetchData();

    super.onInit();
  }
}
