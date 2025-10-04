import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:med_health_app/api/url_api.dart';
import 'package:med_health_app/model/product_model.dart';
import 'package:med_health_app/pages/Search_Page.dart';
import 'package:med_health_app/pages/cart_pages.dart';
import 'package:med_health_app/pages/detail_products.dart';
import 'package:med_health_app/theme.dart';
import 'package:med_health_app/widgets/card_category.dart';
import 'package:http/http.dart' as http;
import 'package:med_health_app/widgets/card_products.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/pref_profile_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userID;
  bool filter = false;
  int? index;
  List<CategoryWithProducts> listCategory = [];
  List<Product> listProduct = [];
  String orderCart = "0";

  @override
  void initState() {
    super.initState();
    getPref();
    getCategory();
    getProduct();
    totalCart();
  }

  Future<void> getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfileModel.idUser);
    });
    if (userID != null) {
      totalCart(); // Fetch cart count after retrieving user ID
    } else {
      print('User ID is null, skipping totalCart call.');
    }
  }

  getCategory() async {
    listCategory.clear();
    var urlCategory = Uri.parse(BASEURL.categoryWithProduct);
    print(urlCategory);
    final response = await http.get(urlCategory);
    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (var item in data) {
          listCategory.add(CategoryWithProducts.fromJson(item));
        }
      });
    } else {
      print('Failed to load categories, status: ${response.statusCode}');
    }
  }

  getProduct() async {
    listProduct.clear();
    var urlProduct = Uri.parse(BASEURL.getProduct);
    print(urlProduct);
    final response = await http.get(urlProduct);

    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body);
        for (var item in data) {
          listProduct.add(Product.fromJson(item));
        }
      });
    } else {
      print('Failed to load products, status: ${response.statusCode}');
    }
  }

  Future<void> totalCart() async {
    if (userID == null) return; // Ensure userID is available
    var url = Uri.parse(BASEURL.getTotalCart(userID!));
    try {
      var response = await http.post(
        url,
        body: {'user_ID': userID!}, // Send user_ID
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] == false) {
          setState(() {
            orderCart = data['cart_count'].toString();
            print('Cart count updated: $orderCart');
          });
        } else {
          print('Error in response: ${data['message']}');
        }
      } else {
        print('Failed to load cart data, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addToCart(String productId) async {
    var url = Uri.parse(BASEURL.addToCart);
    try {
      var response = await http.post(
        url,
        body: {'user_ID': userID.toString(), 'product_ID': productId},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          print('Product added to cart');
          totalCart(); // Fetch updated cart count
        } else {
          print('Failed to add product: ${data['message']}');
        }
      } else {
        print('Failed to add product, status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      width: 155,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Find a medicine or\nvitamins with MedHealth",
                      style: regularTextStyle.copyWith(
                          fontSize: 20, color: greyBoldColor),
                    ),
                  ],
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CartPage()));
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                      color: greenColor,
                    ),
                     if (orderCart != "0")

                      Positioned(
                        right: 10,
                        top: 10,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              orderCart,
                              style: regularTextStyle.copyWith(
                                  color: whiteColor, fontSize: 12),
                            ),
                          ),
                        ),
                      ),


                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffe4faf0),
                ),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xffb1d8b2)),
                      hintText: "Search Medicine",
                      hintStyle: regularTextStyle.copyWith(
                          color: const Color(0xffb0d8b2))),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Medicine and Vitamins by Category",
              style: regularTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              itemCount: listCategory.length > 8 ? 8 : listCategory.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, i) {
                final x = listCategory[i];
                return InkWell(
                  onTap: () {
                    setState(() {
                      index = i;
                      filter = true;
                    });
                  },
                  child: CardCategory(
                    imageCategory: x.image,
                    nameCategory: x.category,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              "Products",
              style: regularTextStyle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              itemCount: filter
                  ? listCategory[index!].product.length > 8
                  ? 8
                  : listCategory[index!].product.length
                  : listProduct.length > 8
                  ? 8
                  : listProduct.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 6.0,
                crossAxisSpacing: 6.0,
                childAspectRatio: 0.80,
              ),
              itemBuilder: (context, i) {
                final y = filter
                    ? listCategory[index!].product[i]
                    : listProduct[i];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProducts(y),
                      ),
                    );
                  },
                  child: CardProducts(
                    imageProduct: y.imageProduct,
                    nameProduct: y.nameProduct,
                    price: y.price,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
