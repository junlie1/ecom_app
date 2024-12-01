import 'dart:convert';

class Cart {
  final String name;
  final String price;
  final String image;
  int quantity;
  final String productId;
  final String description;

  Cart({required this.name, required this.price, required this.image, required this.quantity, required this.productId, required this.description,});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
      'productId': productId,
      'description': description,
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
      name: map['name'] as String,
      price: map['price'] as String,
      image: map['image'] as String,
      quantity: map['quantity'] as int,
      productId: map['productId'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source) as Map<String, dynamic>);
}