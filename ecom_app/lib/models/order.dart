import 'dart:convert';

class Order {
  final String id;
  final List<OrderItem> orderItems;
  final ShippingAddress shippingAddress;
  final String paymentMethod;
  final double itemsPrice;
  final double shippingPrice; // Thêm trường này
  final double totalPrice;
  final String user;

  Order({
    required this.id,
    required this.orderItems,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.itemsPrice,
    required this.shippingPrice, // Thêm trường này
    required this.totalPrice,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'orderItems': orderItems.map((item) => item.toMap()).toList(),
      'shippingAddress': shippingAddress.toMap(),
      'paymentMethod': paymentMethod,
      'itemsPrice': itemsPrice,
      'shippingPrice': shippingPrice, // Thêm trường này
      'totalPrice': totalPrice,
      'user': user,
    };
  }

  String toJson() => jsonEncode(toMap());
}


class OrderItem {
  final String name;
  final int amount;
  final String image;
  final int price;
  final String product;

  OrderItem({
    required this.name,
    required this.amount,
    required this.image,
    required this.price,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'image': image,
      'price': price,
      'product': product,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      amount: map['amount'] ?? 0,
      image: map['image'] ?? '',
      price: map['price'] ?? 0,
      product: map['product'] ?? '',
    );
  }
}

class ShippingAddress {
  final String fullName;
  final String address;
  final String city; // Thêm trường này
  final int phone; // Thay đổi từ String sang int

  ShippingAddress({
    required this.fullName,
    required this.address,
    required this.city, // Thêm trường này
    required this.phone, // Thay đổi từ String sang int
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address': address,
      'city': city, // Thêm trường này
      'phone': phone, // Giữ nguyên là số
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      fullName: map['fullName'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? 'Hồ Chí Minh', // Gán mặc định nếu null
      phone: map['phone'] ?? 0, // Gán mặc định nếu null
    );
  }
}

