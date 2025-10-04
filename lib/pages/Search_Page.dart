import 'dart:convert'; // For decoding JSON responses.
import 'package:flutter/material.dart'; // Flutter UI framework.
import 'package:med_health_app/model/product_model.dart'; // Product model.
import 'package:med_health_app/pages/detail_products.dart';
import 'package:med_health_app/theme.dart'; // Custom theme settings.
import 'package:http/http.dart' as http; // HTTP package for API calls.
import '../api/url_api.dart'; // Contains API URLs.
import '../widgets/card_products.dart'; // Widget for displaying products.

// SearchPage widget with StatefulWidget for maintaining state.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key}); // Constructor with optional key.

  @override
  State<SearchPage> createState() => _SearchPageState(); // Create state.
}

class _SearchPageState extends State<SearchPage> {
  List<Product> listproducts = []; // Full list of products from API.
  List<Product> filteredProducts = []; // Filtered products based on search.
  TextEditingController searchController = TextEditingController(); // Controller for search input.

  @override
  void initState() {
    super.initState();
    getProduct(); // Fetch products on widget initialization.
  }

  // Fetch products from API.
  getProduct() async {
    listproducts.clear(); // Clear the product list to prevent duplication.
    var urlProduct = Uri.parse(BASEURL.getProduct); // API endpoint.
    final response = await http.get(urlProduct); // Send GET request.

    if (response.statusCode == 200) {
      setState(() {
        final data = jsonDecode(response.body); // Parse JSON response.
        for (var item in data) {
          listproducts.add(Product.fromJson(item)); // Add products to list.
        }
        filteredProducts = List.from(
            listproducts); // Initialize filtered list with all products.
      });
    } else {
      print('Failed to load products, status: ${response
          .statusCode}'); // Log errors.
    }
  }

  // Filter products based on search query.
  void filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        // If query is empty, reset to the full product list.
        filteredProducts = List.from(listproducts);
      } else {
        // Filter products by checking if the name contains the query.
        filteredProducts = listproducts
            .where((product) =>
            product.nameProduct.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            // Search bar section.
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button.
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back.
                    },
                    icon: Icon(
                        Icons.arrow_back_rounded, size: 32, color: greenColor),
                  ),
                  // Search input field.

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffe4faf0), // Background color.
                    ),
                    child: TextField(
                      autofocus: true,
                      controller: searchController,
                      // Attach controller.
                      onChanged: filterProducts,
                      // Call filter function on input change.
                      decoration: InputDecoration(
                        border: InputBorder.none, // No border.
                        prefixIcon: const Icon(Icons.search, color: Color(
                            0xffb1d8b2)),
                        hintText: "Search Medicine", // Placeholder text.
                        hintStyle: regularTextStyle.copyWith(color: const Color(
                            0xffb0d8b2)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // If the search field is empty, show the image and subtitle.
            if (searchController.text.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/no_data_ilustration.png",
                      width: 300,

                    ),

                    const SizedBox(height: 16),
                    Text(
                      "Start by typing to search", // Subtitle.
                      style: TextStyle(fontSize: 25, color: Colors.black,fontWeight: FontWeight.bold ),
                    ),
                    Text(
                      "Find the product you want\n products will appear here!", // Subtitle.
                      style: TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                  ],
                ),
              )
            // If search results are empty, show a "No products found" message.
            else
              if (filteredProducts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "No products found", // Message to display.
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              // Otherwise, display the product grid.
              else
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    // Number of filtered products.
                    shrinkWrap: true,
                    // Shrink grid to fit content.
                    physics: const NeverScrollableScrollPhysics(),
                    // Disable scrolling (scroll managed by parent ListView).
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns.
                      mainAxisSpacing: 6.0, // Vertical spacing.
                      crossAxisSpacing: 6.0, // Horizontal spacing.
                      childAspectRatio: 0.80, // Aspect ratio of grid items.
                    ),
                    itemBuilder: (context, i) {
                      final product = filteredProducts[i]; // Get product at index.
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailProducts(product), // Pass the selected product.
                            ),
                          );
                        },
                        child: CardProducts(

                          imageProduct: product.imageProduct, // Product image.
                          nameProduct: product.nameProduct, // Product name.
                          price: product.price, // Product price.
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}