import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_health_app/theme.dart';

class CardProducts extends StatelessWidget {
  final String imageProduct;
  final String nameProduct;
  final String price;
  CardProducts(
      {required this.imageProduct,
      required this.nameProduct,
      required this.price});

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat("#,##0","EN_US");
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Image.network(
          imageProduct,
          width: 115,
          height: 100,
        ),
        SizedBox(
          height: 10,
        ),
        Text(nameProduct),
        SizedBox(
          height: 8,
        ),
        Text("LBP" + priceFormat.format(int.parse(price))),
      ]),
    );
  }
}
