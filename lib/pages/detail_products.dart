import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_health_app/api/url_api.dart';
import 'package:med_health_app/model/pref_profile_model.dart';
import 'package:med_health_app/model/product_model.dart';
import 'package:med_health_app/pages/main_page.dart';
import 'package:med_health_app/theme.dart';
import 'package:med_health_app/widgets/button_primary.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailProducts extends StatefulWidget {
  final Product product;
  DetailProducts(this.product);

  @override
  State<DetailProducts> createState() => _DetailProductsState();
}

class _DetailProductsState extends State<DetailProducts> {
  final priceformat = NumberFormat("#,##0", "EN_US");

  String? userId;
  bool isLoading = true;

  // Fetch user id from SharedPreferences
  getPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId = sharedPreferences.getString(PrefProfileModel.idUser);
      isLoading = false;  // After fetching the userId, update isLoading
    });
  }

  // Add product to the cart
  addToCart() async {
    if (userId == null) {
      // Handle case when userId is null (not available)
      print("User ID is not available");
      return;
    }

    var urlAddToCart = Uri.parse(BASEURL.addToCart);
    final response = await http.post(urlAddToCart, body: {
      "id_user": userId,
      "id_product": widget.product.idProduct,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int value = data['value'];
      String message = data['message'];

      if (value == 1) {
        // Show success dialog
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Information"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        print(message);
      }
    } else {
      // Handle the error if status code is not 200
      print("Failed to add to cart. Status code: ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();  // Fetch user id when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading spinner until userId is fetched
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              height: 70,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_rounded, size: 32, color: greenColor),
                  ),
                  SizedBox(width: 30),
                  Text("Detail Product", style: regularTextStyle.copyWith(fontSize: 25)),
                ],
              ),
            ),
            SizedBox(height: 24),
            Container(
              height: 200,
              color: Colors.white,
              child: Image.network(widget.product.imageProduct),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.nameProduct, style: regularTextStyle.copyWith(fontSize: 25)),
                  SizedBox(height: 15),
                  Text(
                    widget.product.description,
                    style: regularTextStyle.copyWith(fontSize: 14, color: Colors.blueGrey),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Spacer(),
                      Text(
                        "LBP " + priceformat.format(int.parse(widget.product.price)),
                        style: boldTextStyle.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ButtonPrimary(
                        text: "ADD TO CART",
                        onTap: () {
                          
                          addToCart();
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
