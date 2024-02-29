import 'package:flutter/material.dart';
import 'package:flutter_cart_sqflite/helper/themes.dart';
import 'package:flutter_cart_sqflite/homepage/controller/homepage_controller.dart';
import 'package:flutter_cart_sqflite/homepage/view/favorite_page_view.dart';
import 'package:flutter_cart_sqflite/model/product_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomepageController());
    final Size mediaQuery = MediaQuery.of(context).size;
    final double width = mediaQuery.width;
    final double height = mediaQuery.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("L'Oréal"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => FavoritePageview())?.then((value) {
                controller.checkCart();
              });
            },
            icon: Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center();
            } else {
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: height * 0.50,
                  childAspectRatio: 1 / 2,
                  crossAxisSpacing: width * 0.04,
                  mainAxisSpacing: 2,
                ),
                itemCount: controller.data.length,
                itemBuilder: (context, index) {
                  ProductModel product = controller.data[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Image.network(product.imageLink ?? '',
                                fit: BoxFit.cover),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.015),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(product.name!),
                                  ),
                                  Text("\$ ${product.price!}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          return IconButton(
                            onPressed: () {
                              if (controller.isCart[index].value == false) {
                                controller.addToCart(
                                  imageLink: product.imageLink!,
                                  title: product.name!,
                                  price: product.price!,
                                  id: product.id!,
                                );
                              } else {
                                controller.deleteFromCart(product.id!);
                              }
                              controller.isCart[index].toggle();
                            },
                            icon: Icon(
                              controller.isCart[index].value == false
                                  ? Icons.shopping_cart_outlined
                                  : Icons.shopping_cart_rounded,
                              size: 20,
                              color: primaryColor,
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }
}
