import 'package:flutter/material.dart';
import 'package:flutter_cart_sqflite/helper/themes.dart';
import 'package:flutter_cart_sqflite/homepage/controller/favorite_page_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePageview extends StatelessWidget {
  const FavoritePageview({Key? key});

  @override
  Widget build(BuildContext context) {
    final Size mediaQuery = MediaQuery.of(context).size;
    final double width = mediaQuery.width;
    final double height = mediaQuery.height;

    final controller = Get.put(FavoritePageController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("Shopping Cart"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
           Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.makeup.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: ListTile(
                            title: Text('${controller.makeup[index]["title"]}'),
                            subtitle: Text('\$ ${controller.makeup[index]["price"]}'),
                            leading: Image.network("${controller.makeup[index]["imageLink"]}"),
                            trailing: IconButton(
                              onPressed: () {
                                controller.deleteFromCart(
                                  controller.makeup[index]["id"]!,
                                  index,
                                );
                              },
                              icon: Icon(
                                Icons.delete_sweep,
                                color: warningColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            
          ],
        ),
      ),
    );
  }
}
