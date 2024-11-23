import 'dart:convert';

import 'package:ecom_tieuluan_app/global_varibales.dart';
import 'package:ecom_tieuluan_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductController {
  Future<List<Product>> loadPopularProduct() async {
    try {
      http.Response response = await http.get(
          Uri.parse("$uri/api/product/get-all"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      print(response.body);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        // Kiểm tra cấu trúc của JSON phản hồi
        if (body is Map<String, dynamic> && body['data'] is List) {
          // Ánh xạ danh sách sản phẩm
          return (body['data'] as List)
              .map((product) => Product.fromMap(product))
              .toList();
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    }
    catch(e) {
      throw Exception("Error loading product: $e");
    }
  }
}