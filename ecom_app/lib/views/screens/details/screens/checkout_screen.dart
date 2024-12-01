import 'package:ecom_app/controllers/order_controller.dart';
import 'package:ecom_app/models/order.dart';
import 'package:ecom_app/provider/cart_provider.dart';
import 'package:ecom_app/provider/user_provider.dart';
import 'package:ecom_app/services/manage_http_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String selectedPaymentMethod = "Stripe";
  final OrderController _orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    final cartData = ref.read(cartProvider); // Dữ liệu từ provider
    final cartNotifier = ref.read(cartProvider.notifier);
    final user = ref.watch(userProvider);
    // final orders = ref.read(orderProvider);
    bool isLoading = false;
    Future<void> handleStripePayment(BuildContext context) async {
      final cartData = ref.read(cartProvider);
      if (cartData.isEmpty) {
        showSnackBar(context, "Giỏ hàng đang trống");
        return;
      }
      try {
        setState(() {
          isLoading = true;
        });

        // Tỷ giá hối đoái VNĐ -> USD (cần cập nhật tỷ giá theo thời gian thực nếu cần)
        const double exchangeRateToUSD = 24000.0; // 1 USD = 24,000 VNĐ

        // Tính tổng tiền (VNĐ) từ giỏ hàng
        final double totalAmountVND = cartData.values.fold(0.0, (sum, item) {
          return sum + (item.quantity * double.parse(item.price)); // Giá hiện tại đang là VNĐ
        });
        print("totalAmountVND: ${totalAmountVND}");

        if (totalAmountVND <= 0) {
          showSnackBar(context, "Tổng tiền phải lớn hơn 0");
          return;
        }

        // Chuyển đổi sang USD
        final double totalAmountUSD = totalAmountVND / exchangeRateToUSD;
        print("totalAmountUSD: ${totalAmountUSD}");

        // Tạo payment intent với số tiền tính theo cent (USD * 100)
        final paymentIntent = await _orderController.createPaymentIntent(
          amount: (totalAmountUSD * 100).toInt(),
          currency: 'usd',
        );
        print('paymentIntent ${paymentIntent}');

        // Khởi tạo form thanh toán
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent['client_secret'],
            merchantDisplayName: 'Nhom3',
          ),
        );

        // Hiển thị form thanh toán
        await Stripe.instance.presentPaymentSheet();

        // Tạo thông tin địa chỉ giao hàng
        final shippingAddress = ShippingAddress(
          fullName: user!.name,
          address: user.address,
          phone: user.phone,
          city: user.city,
        );
        print("Shipping Address: ${shippingAddress.toMap()}");

        // Lấy danh sách sản phẩm trong giỏ hàng
        final List<OrderItem> orderItems = cartNotifier.getCartItems.entries.map((entry) {
          final item = entry.value;
          return OrderItem(
            name: item.name,
            amount: item.quantity,
            image: item.image,
            price: (double.parse(item.price) / exchangeRateToUSD).toInt(), // Chuyển giá từng sản phẩm sang USD
            product: item.productId,
          );
        }).toList();

        print("Order Items: ${orderItems.map((e) => e.toMap()).toList()}");

        // Tính giá tổng cho sản phẩm và vận chuyển (USD)
        final double itemPriceUSD = cartNotifier.getCartItems.entries.fold<double>(
          0.0,
              (sum, entry) => sum + (double.parse(entry.value.price) / exchangeRateToUSD) * entry.value.quantity,
        );

        final double shippingPriceUSD = 20.0; // Giá vận chuyển cố định bằng USD
        final double totalPriceUSD = itemPriceUSD + shippingPriceUSD;

        print("Items Price: $itemPriceUSD, Shipping Price: $shippingPriceUSD, Total: $totalPriceUSD");

        // Xác thực trạng thái payment intent
        final paymentIntentStatus = await _orderController.getPaymentIntentStatus(
          context: context,
          paymentIntentId: paymentIntent['id'],
        );

        if (paymentIntentStatus['status'] == 'succeeded') {
          // Gửi thông tin đơn hàng
          for (final entry in cartData.entries) {
            final item = entry.value;
            await _orderController.uploadOrders(
              paymentMethod: "stripe",
              itemsPrice: itemPriceUSD,
              shippingPrice: shippingPriceUSD,
              totalPrice: totalPriceUSD,
              shippingAddress: shippingAddress,
              orderItems: orderItems,
              user: user.id,
              context: context,
            );
          }
        }
      } catch (e) {
        print("Lỗi: $e");
        showSnackBar(context, "Thanh toán thất bại, vui lòng thử lại.");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            "Checkout"
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 15,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context){
                  //   return const ShippingAddressScreen();
                  // }));
                },
                child: SizedBox(
                  width: 350,
                  height: 74,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      //Khung chứa địa chỉ
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 335,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.lightBlueAccent
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      //Column Text
                      Positioned(
                        left: 70,
                        top: 17,
                        child: SizedBox(
                          width: 215,
                          height: 41,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -1,
                                left: -1,
                                child: SizedBox(
                                  width: 300,
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: SizedBox(
                                              width: 100,
                                              child: Text(
                                                'Địa chỉ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: user!.address.isNotEmpty
                                                ? Text(
                                              user.address,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue
                                              ),
                                            )
                                                :const Text(
                                              'Việt Nam',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.3,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: user.name.isNotEmpty
                                                ?Text(user.name,style: const TextStyle(color: Colors.black45),)
                                                : const Text(
                                              'Enter locality',
                                              style: TextStyle(
                                                color: Color(0xFF7F808C),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const Text("SĐT: "),
                                      Text(user.phone.toString()),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Icon địa chỉ
                      Positioned(
                        left: 16,
                        top: 16,
                        child: SizedBox.square(
                          dimension: 42,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 43,
                                  height: 43,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.hardEdge,
                                    children: [
                                      Positioned(
                                        left: 11,
                                        top: 11,
                                        child: Image.network(
                                          height: 26,
                                          width: 26,
                                          'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F2ee3a5ce3b02828d0e2806584a6baa88.png',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      //Icon Chỉnh sửa
                      Positioned(
                        left: 305,
                        top: 25,
                        child: Image.network(
                          width: 20,
                          height: 20,
                          'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2Fnn2Ldqjoc2Xp89Y7Wfzf%2F6ce18a0efc6e889de2f2878027c689c9caa53feeedit%201.png?alt=media&token=a3a8a999-80d5-4a2e-a9b7-a43a7fa8789a',
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10,),
/*Text*/
              const Text(
                "Your Item",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),

/*Danh sách item*/
              Flexible(
                  child: ListView.builder(
                      itemCount: cartData.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index) {
                        final cartItem = cartData.values.toList()[index];
                        return InkWell(
                          onTap: () {

                          },
                          child: Container(
                            width: 180,
                            height: 91,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: const Color(0xEAB7C8FF)),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.network(cartItem.image),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 25),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartItem.name,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold
                                            ),
                                            softWrap: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        "\$${cartItem.price.toString()} x ${cartItem.quantity}",
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }
                  )
              ),

              const SizedBox(height: 10,),
/*Chọn cách thức chuyển tiền*/
              const Text(
                "Choose Payment Method",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),

              RadioListTile<String>(
                  title: const Text(
                    "Stripe",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  value: "Stripe",
                  groupValue: selectedPaymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  }
              ),
              RadioListTile<String>(
                  title: const Text(
                    "Cash on delivery",
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                  value: "cashOnDelivery",
                  groupValue: selectedPaymentMethod,
                  onChanged: (String? value) {
                    setState(() {
                      selectedPaymentMethod = value!;
                    });
                  }
              ),
            ],
          ),
        ),
      ),
/*Kiểm tra đã có địa chỉ chưa?*/
      bottomNavigationBar: user.address.isEmpty
          ? TextButton(
          onPressed: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //   return const ShippingAddressScreen();
            // }));
          },
          child: const Text("Hãy nhập địa chỉ của bạn",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
      )
          :InkWell(
        onTap: () async{
          if(selectedPaymentMethod == "Stripe") {
            handleStripePayment(context);
          }
          else{
            print("đã ấn cash on delivery");
            try {
              final shippingAddress = ShippingAddress(
                fullName: user.name,
                address: user.address,
                phone: user.phone,
                city: user.city,
              );
              print("Shipping Address: ${shippingAddress.toMap()}");

              final List<OrderItem> orderItems = cartNotifier.getCartItems.entries.map((entry) {
                final item = entry.value;
                return OrderItem(
                  name: item.name,
                  amount: item.quantity,
                  image: item.image,
                  price: int.parse(item.price),
                  product: item.productId,
                );
              }).toList();

              print("Order Items: ${orderItems.map((e) => e.toMap()).toList()}");

              final itemPrice = cartNotifier.getCartItems.entries.fold<double>(
                0.0,
                    (sum, entry) => sum + double.parse(entry.value.price.toString()) * entry.value.quantity.toDouble(),
              );

              final shippingPrice = 20.0; // Giá vận chuyển cố định (có thể tùy chỉnh)
              print("Items Price: $itemPrice, Shipping Price: $shippingPrice, Total: ${itemPrice + shippingPrice}");

              await _orderController.uploadOrders(
                paymentMethod: "cod",
                itemsPrice: itemPrice,
                shippingPrice: shippingPrice,
                totalPrice: itemPrice + shippingPrice,
                shippingAddress: shippingAddress,
                orderItems: orderItems,
                user: user.id,
                context: context,
              );
            } catch (e) {
              // In ra lỗi để giúp bạn kiểm tra và sửa lỗi
              print("Error during order placement: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Có lỗi xảy ra khi đặt hàng: $e"))
              );
            }
          }
        },
        child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    selectedPaymentMethod == "Stripe" ? "Pay now" : "Place order",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                  )
              )
          ),
        ),
      ),
    );
  }
}
