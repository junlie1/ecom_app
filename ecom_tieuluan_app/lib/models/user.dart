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

  });

  //sử dụng khi cần tuần tự hóa đối tượng User hoặc truyền nó qua các API
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'token': token,
    };
  }

  // Mỗi thuộc tính của User được lấy từ cặp khóa-giá trị tương ứng trong Map.
  // Nếu bất kỳ khóa nào không tồn tại trong Map, nó sẽ được mặc định là chuỗi rỗng ("").
  factory User.fromMap(Map<String,dynamic> map) {
    return User (
      id: map['_id'] as String? ?? "",
      name: map['name'] as String? ?? "",
      email: map['email'] as String? ?? "",
      password: map['password'] as String? ?? "",
      confirmPassword: map['confirmPassword'] as String? ?? "",
      phone: map['phone'] as int? ?? 0,
      address: map['address'] as String? ?? "",
      avatar: map['avatar'] as String? ?? "",
      token: map['token'] as String? ?? "",
    );
  }
  //Convert object User to json
  //Từ user -> Map,dùng encode để chuyển thằng map thành json
  String toJson() => jsonEncode(toMap());

  //nhận dữ liệu JSON từ một API
  //chuyển đổi nó thành đối tượng User trong ứng dụng.
  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}