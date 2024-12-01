import 'dart:convert';
import 'package:ecom_app/global_varibales.dart';
import 'package:ecom_app/models/order.dart';
import 'package:ecom_app/services/manage_http_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OrderController {
  Future<void> uploadOrders({
    required String paymentMethod,
    required double itemsPrice,
    required double shippingPrice, // Thêm phí vận chuyển
    required double totalPrice,
    required ShippingAddress shippingAddress,
    required List<OrderItem> orderItems,
    required String user,
    required BuildContext context,
  }) async {
    try {
      // Tạo đối tượng Order
      final Order order = Order(
        id: '', // ID sẽ do backend tạo
        orderItems: orderItems,
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        itemsPrice: itemsPrice,
        shippingPrice: shippingPrice, // Gửi phí vận chuyển
        totalPrice: totalPrice,
        user: user,
      );

      // Gửi yêu cầu POST tới backend
      http.Response response = await http.post(
        Uri.parse("$uri/api/order/create-app"), // Đảm bảo endpoint đúng
        body: order.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );
      print('response.body: ${response.body}');

      // Xử lý phản hồi
      managerHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Bạn đã đặt hàng thành công!");
        },
      );
    } catch (e) {
      print("Error in uploadOrders: $e");
      showSnackBar(context, "Có lỗi xảy ra: $e");
    }
  }

  // Tạo Payment Intent
  Future<Map<String, dynamic>> createPaymentIntent({
    required int amount,
    required String currency,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/order/payment-app"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({
          "amount": amount,
          "currency": currency,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Fail to create payment intent: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error in createPaymentIntent: $e");
    }
  }

  // Lấy trạng thái Payment Intent
  Future<Map<String, dynamic>> getPaymentIntentStatus({
    required BuildContext context,
    required String paymentIntentId,
  }) async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/order/payment-app-intent/$paymentIntentId"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Fail to fetch payment status: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error in getPaymentIntentStatus: $e");
    }
  }
}
