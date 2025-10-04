class CategoryWithProducts {
  final String idCategory;
  final String category;
  final String image;
  final String status;
  final List<Product> product;

  CategoryWithProducts({
    required this.idCategory,
    required this.category,
    required this.image,
    required this.status,
    required this.product, // Now defined as a named parameter
  });

  factory CategoryWithProducts.fromJson(Map<String, dynamic> data) {
    var list = data['product'] as List;
    List<Product> listProduct = list.map((e) => Product.fromJson(e)).toList();

    return CategoryWithProducts(
      idCategory: data['idCategory'],
      category: data['category'],
      image: data['image'],
      status: data['status'],
      product: listProduct, // Passing listProduct to product parameter
    );
  }
}

class Product {
  final String idProduct;
  final String idCategory;
  final String nameProduct;
  final String description;
  final String imageProduct;
  final String price;
  final String status;
  final String createdAt;

  Product({
    required this.idProduct,
    required this.idCategory,
    required this.nameProduct,
    required this.description,
    required this.imageProduct,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduct: json['id_product'],
      idCategory: json['id_category'],
      nameProduct: json['name'],
      description: json['description'],
      imageProduct: json['image'],
      price: json['price'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
