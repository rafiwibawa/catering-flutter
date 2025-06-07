class Menu {
  final int id;
  final String name;
  final String image;
  final String price;

  Menu({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'].toString(),
    );
  }
}
