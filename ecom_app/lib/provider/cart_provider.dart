import 'dart:convert';
import 'package:ecom_app/models/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartNotifier extends StateNotifier<Map<String, Cart>> {
  CartNotifier() : super({}) {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartString = prefs.getString('cart_items');
    if (cartString != null) {
      final Map<String, dynamic> cartMap = jsonDecode(cartString);

      final cartItems =cartMap.map((key, value) => MapEntry(key, Cart.fromJson(value)));

      state = cartItems;
    }
  }

//A private method that saves the current list of favorite items to sharedpreferences
  Future<void> _saveCartItems() async {
    //retrieving the sharepreferences instance to store data
    final prefs = await SharedPreferences.getInstance();
    //encoding the current state (Map of favorite object ) into json String
    final cartString = jsonEncode(state);
    //saving the json string to sharedpreferences with the key "favorites"
    await prefs.setString('cart_items', cartString);
  }

  //Method to add product to the cart
  void addProductToCart({
    required String name,
    required String price,
    required String image,
    required int quantity,
    required String productId,
    required String description,
  }) {
    //check if the product is already in the cart
    if (state.containsKey(productId)) {
      //if the product is already in the cart, update its quantity and maybe other detail
      state = {
        ...state,
        productId: Cart(
          name: state[productId]!.name,
          price: state[productId]!.price,
          image: state[productId]!.image,
          quantity: state[productId]!.quantity + 1,
          productId: state[productId]!.productId,
          description: state[productId]!.description,
        )
      };
      _saveCartItems();
    } else {
      // if the product is not in the cart, add it with the provied  details
      state = {
        ...state,
        productId: Cart(
            name: name,
            price: price,
            image: image,
            quantity: quantity,
            productId: productId,
            description: description,
        )
      };

      _saveCartItems();
    }
  }

//Method to increment the quantity   of a product  in the cart
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity++;

      //Notify listeners that the state  has changed
      state = {...state};
      _saveCartItems();
    }
  }

  //Method to decrement the quantity of a product in the cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.quantity--;

      //Notify listerners that the state has changed
      state = {...state};
      _saveCartItems();
    }
  }

  //Method to remove item from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    //Notify Listerners that the state has changed

    state = {...state};
    _saveCartItems();
  }

  //Method to calculate total amount of items we have in cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.quantity * double.parse(cartItem.price);
    });

    return totalAmount;
  }

  //Method to clear all items in the cart
  void clearCart() {
    state = {};
    //Notify Listerners that the state has changed

    state = {...state};

    _saveCartItems();
  }

  Map<String, Cart> get getCartItems => state;
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, Cart>>((ref) {
  return CartNotifier();
});