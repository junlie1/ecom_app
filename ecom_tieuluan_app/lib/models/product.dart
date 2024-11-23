class Product {
  final String id;
  final String name;
  final String image;
  final String type;
  final int price; // Chuyển từ String thành int
  final int countInStock;
  final double rating;
  final String description;
  final int? discount; // Trường mới, có thể null
  final int? selled; // Trường mới, có thể null

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.price,
    required this.countInStock,
    required this.rating,
    required this.description,
    this.discount, // Trường mới
    this.selled, // Trường mới
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: (map['_id'] ?? '').toString(),
      name: (map['name'] ?? '').toString(),
      image: (map['image'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      price: int.tryParse(map['price'].toString()) ?? 0, // Chuyển price từ String thành int
      countInStock: map['countInStock'] != null ? map['countInStock'] as int : 0,
      rating: map['rating'] != null ? (map['rating'] as num).toDouble() : 0.0,
      description: (map['description'] ?? '').toString(),
      discount: map['discount'] != null ? map['discount'] as int : null, // Xử lý discount
      selled: map['selled'] != null ? map['selled'] as int : null, // Xử lý selled
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'type': type,
      'price': price,
      'countInStock': countInStock,
      'rating': rating,
      'description': description,
      'discount': discount,
      'selled': selled,
    };
  }
}
