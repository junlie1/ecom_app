import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final int phone;
  final String avatar;
  final String address;
  final String token;
  final String city; // Thành phố

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.address,
    required this.avatar,
    required this.token,
    required this.city, // Bao gồm city trong constructor
  });

  // Sử dụng khi cần tuần tự hóa đối tượng User hoặc truyền nó qua các API
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'token': token,
      'city': city, // Bao gồm city trong toMap
    };
  }

  // Xử lý city mặc định là "Hồ Chí Minh" nếu không tồn tại hoặc null
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String? ?? "",
      name: map['name'] as String? ?? "",
      email: map['email'] as String? ?? "",
      password: map['password'] as String? ?? "",
      confirmPassword: map['confirmPassword'] as String? ?? "",
      phone: map['phone'] as int? ?? 0,
      address: map['address'] as String? ?? "",
      avatar: map['avatar'] as String? ?? "",
      token: map['token'] as String? ?? "",
      city: map['city'] as String? ?? "Hồ Chí Minh", // Nếu null, đặt mặc định là "Hồ Chí Minh"
    );
  }

  // Convert object User to json
  String toJson() => jsonEncode(toMap());

  // Chuyển từ JSON sang đối tượng User
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
