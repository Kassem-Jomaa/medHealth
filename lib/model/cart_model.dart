class CartModel {
  final String idCart;
  final String quantity;
  final String name;
  final String image;
  final String price;

  CartModel({
    required this.idCart,
    required this.quantity,
    required this.name,
    required this.image,
    required this.price,
  });

  // Factory constructor to create a CartModel from JSON
  factory CartModel.fromJson(json) {
    return CartModel(
      idCart: json['id_cart'],    // Map JSON key 'id_cart' to idCart
      quantity: json['quantity'], // Map JSON key 'quantity' to quantity
      name: json['name'],         // Map JSON key 'name' to name
      image: json['image'],       // Map JSON key 'image' to image
      price: json['price'],       // Map JSON key 'price' to price
    );
  }
}
