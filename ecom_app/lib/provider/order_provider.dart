//
// import 'package:dacn_nhom3_customer/models/order.dart';
// import 'package:ecom_app/models/order.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class OrderProvider extends StateNotifier<List<Order>> {
//   OrderProvider() : super([]);
//
//   //set the list of Orders
//   void setOrders(List<Order> orders) {
//     state = orders;
//   }
//
//   /*Trạng thái order real time*/
//
//   void updateOrderStatusRealtime(String orderId, {bool? processing,bool? shipping, bool? delivered, bool? isPaid}) {
//     //Update trạng thái của provider với danh sách order mới
//     state = [
//       //Lặp qua các đơn hàng hiện có
//       for(final order in state)
//       //Kiểm tra xem ID của đơn hàng hiện tại có khớp với ID mà chúng ta muốn cập nhật hay không
//       //so sánh ID của đơn hànghiện tại với một ID cụ thể thực hiện cập nhật
//       //để tìm đơn hàng cụ thể cần chỉnh sửa.
//         if(order.id == orderId)
//         //Có thì tạo 1 object Order mới
//           Order(
//               id: order.id,
//               orderItems: ,
//               shippingAddress: shippingAddress,
//               paymentMethod: order.paymentMethod,
//               itemsPrice: order.itemsPrice,
//               totalPrice: order.totalPrice,
//               user: order.user
//           )
//         //Nếu không trùng giữ nguyên
//         else
//           order
//     ];
//   }
//
// }
// final orderProvider = StateNotifierProvider<OrderProvider,List<Order>>(
//         (ref) {
//       return OrderProvider();
//     }
// );
