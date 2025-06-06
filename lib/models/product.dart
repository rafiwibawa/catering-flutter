class Product {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final int categoryId;
  final Map<String, dynamic> category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image'],
      price: double.parse(json['price'].toString()),
      categoryId: json['category_id'],
      category: json['category'],
    );
  }
}
