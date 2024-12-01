import 'package:ecom_app/provider/cart_provider.dart';
import 'package:ecom_app/views/screens/details/screens/checkout_screen.dart';
import 'package:ecom_app/views/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {

    final cartData = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My cart",
          style: TextStyle(
              color: Colors.lightBlueAccent,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: cartData.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Giỏ hàng đang rỗng\n Chọn sản phẩm bằng cách ấn\n Xem sản phẩm ở dưới",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MainScreen();
                }));
              },
              child: Text("Xem sản phẩm"),
            )
          ],
        ),
      )
          : Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 60,
            decoration: const BoxDecoration(color: Colors.black12),
            child: Center(
              child: Text(
                'You Have ${cartData.length} items',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.7,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.length,
              itemBuilder: (context, index) {
                final cartItem = cartData.values.toList()[index];
                return Card(
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 160,
                          width: 160,
                          child: Image.network(cartItem.image),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartItem.name,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${cartItem.price} VND",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.deepOrangeAccent),
                            ),
                            Container(
                              height: 40,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (cartItem.quantity > 1) {
                                        _cartProvider.decrementCartItem(
                                            cartItem.productId);
                                      } else {
                                        _cartProvider.removeCartItem(
                                            cartItem.productId);
                                      }
                                    },
                                    icon: Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    cartItem.quantity.toStringAsFixed(0),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _cartProvider.incrementCartItem(
                                          cartItem.productId);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.plus,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _cartProvider.removeCartItem(
                                    cartItem.productId);
                              },
                              icon: Icon(
                                CupertinoIcons.delete,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

/*Tổng tiền và Button check out*/
      bottomNavigationBar: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
            color: Colors.blue
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Subtotal:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    ),
                  ),
                ),
                Text(
                  "${totalAmount.toString()} VND",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                  ),
                )
              ],
            ),


            Container(
              height: 80,
              width: 10,
              color: Colors.grey,
            ),

            TextButton(
              onPressed: cartData.isEmpty
                  ? null
                  : () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CheckoutScreen();
                }));
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    return cartData.isEmpty ? Colors.grey : Colors.blue;
                  },
                ),
              ),
              child: Text(
                "Check out",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
