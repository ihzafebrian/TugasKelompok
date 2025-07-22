class Product {
  final int id;
  final String productName;
  final int categoryId;
  final int stock;
  final double? price;

  Product({
    required this.id,
    required this.productName,
    required this.categoryId,
    required this.stock,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['product_name'],
      categoryId: json['category_id'],
      stock: json['stock'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
    );
  }
}
