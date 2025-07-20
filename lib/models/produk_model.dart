class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'], name: json['name'] ?? '');
  }
}

class Supplier {
  final int id;
  final String name;

  Supplier({required this.id, required this.name});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(id: json['id'], name: json['name'] ?? '');
  }
}

class Product {
  final int id;
  final String productName;
  final int categoryId;
  final int supplierId;
  final int price;
  final int stock;
  final String image;
  final Category? category;
  final Supplier? supplier;

  Product({
    required this.id,
    required this.productName,
    required this.categoryId,
    required this.supplierId,
    required this.price,
    required this.stock,
    required this.image,
    this.category,
    this.supplier,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      productName: json['product_name'] ?? '',
      categoryId: json['category_id'] ?? 0,
      supplierId: json['supplier_id'] ?? 0,
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      image: json['image'] ?? '',
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      supplier:
          json['supplier'] != null ? Supplier.fromJson(json['supplier']) : null,
    );
  }
}
