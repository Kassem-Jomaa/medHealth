import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_health_app/api/url_api.dart';
import 'package:med_health_app/model/cart_model.dart';
import 'package:med_health_app/model/pref_profile_model.dart';
import 'package:med_health_app/pages/main_page.dart';
import 'package:med_health_app/theme.dart';
import 'package:med_health_app/widgets/button_primary.dart';
import 'package:med_health_app/widgets/widget_illustration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final price = NumberFormat("#,##0", "EN_US");
  String? userID, fullName, address, phone;
  int delivery = 0;

  List<CartModel> listCart = [];

  @override
  void initState() {
    super.initState();
    getPref();
  }

  Future<void> getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userID = sharedPreferences.getString(PrefProfileModel.idUser);
      fullName = sharedPreferences.getString(PrefProfileModel.name);
      address = sharedPreferences.getString(PrefProfileModel.address);
      phone = sharedPreferences.getString(PrefProfileModel.phone);
    });
    await getCart();
  }

  Future<void> getCart() async {
    if (userID == null) {
      print("User ID is null, cannot fetch cart");
      return;
    }

    listCart.clear();

    try {
      var urlCart = Uri.parse(BASEURL.getProductCart(userID.toString()));
      final response = await http.get(urlCart);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          if (data is List) {
            listCart = data.map((item) => CartModel.fromJson(item)).toList();
          } else if (data is Map<String, dynamic> && data['cart'] is List) {
            listCart = data['cart']
                .map<CartModel>((item) => CartModel.fromJson(item))
                .toList();
          } else {
            print("Unexpected data format: $data");
          }
        });
      } else {
        print("Failed to fetch cart: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching cart: $e");
    }
  }

  Future<void> updateQuantity(String tipe, String cartID) async {
    try {
      var urlUpdateQuantity =
      Uri.parse(BASEURL.updateQuantityCart(userID.toString()));
      final response = await http.post(urlUpdateQuantity, body: {
        "cartID": cartID,
        "tipe": tipe,
      });

      final data = jsonDecode(response.body);
      if (data['value'] == 1) {
        await getCart(); // Refresh cart
      } else {
        print(data['message']);
      }
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  int getTotal() {
    return listCart.fold(
      0,
          (sum, item) => sum + int.parse(item.price) * int.parse(item.quantity),
    );
  }

  Widget infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: regularTextStyle.copyWith(fontSize: 16, color: greyLightColor),
        ),
        Text(
          value,
          style: boldTextStyle.copyWith(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: listCart.isEmpty
          ? const SizedBox()
          : Container(
        padding: const EdgeInsets.all(24),
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            infoRow("Total Items", "${listCart.length}"),
            const SizedBox(height: 16),
            infoRow(
                "Delivery Fees", delivery == 0 ? "Free" : "$delivery LBP"),
            const SizedBox(height: 16),
            infoRow("Total Payment", "LBP ${price.format(getTotal())}"),
            const SizedBox(height: 30),
            ButtonPrimary(text: "Checkout now", onTap: () {}),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 220),
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              height: 70,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_rounded,
                        size: 32, color: greenColor),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    "My Cart",
                    style: regularTextStyle.copyWith(fontSize: 25),
                  ),
                ],
              ),
            ),
            listCart.isEmpty
                ? WidgetIllustration(
                child: ButtonPrimary(
                  text: "Shop Now",
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                          (route) => false,
                    );
                  },
                ),
                image: "assets/empty_cart_ilustration.png",
                subtitle1: "Your cart is still empty",
                subtitle2: "Discover attractive products on MEDHEALTH",
                title: "Oops, no products in your cart")
                : const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Destination",
                    style: regularTextStyle.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  infoRow("Name", fullName ?? "No Name Provided"),
                  const SizedBox(height: 8),
                  infoRow("Address", address ?? "No Address Provided"),
                  const SizedBox(height: 8),
                  infoRow("Phone", phone ?? "No Phone Provided"),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: listCart.length,
              itemBuilder: (context, i) {
                final x = listCart[i];
                return Container(
                  padding: const EdgeInsets.all(24),
                  color: whiteColor,
                  child: Row(
                    children: [
                      Image.network(
                        x.image,
                        width: 115,
                        height: 115,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              x.name,
                              style:
                              regularTextStyle.copyWith(fontSize: 16),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      updateQuantity("Add", x.idCart),
                                  icon: Icon(Icons.add_circle,
                                      color: greenColor),
                                ),
                                Text(x.quantity),
                                IconButton(
                                  onPressed: () =>
                                      updateQuantity("Minus", x.idCart),
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Text(
                              "LBP ${price.format(int.parse(x.price))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
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
