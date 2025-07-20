class Category {
  final int id;
  final String categoryName;

  Category({required this.id, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryName: json['category_name'] ?? '', // penting: cegah null
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'category_name': categoryName};
  }

  @override
  String toString() => categoryName; // untuk dropdown
}
