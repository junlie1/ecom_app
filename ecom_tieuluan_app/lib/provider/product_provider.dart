import 'package:ecom_tieuluan_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductProvider extends StateNotifier<List<Product>> {
  ProductProvider() : super([]);

  //Set product
  void setProduct(List<Product> products) {
    state = products;
  }
}

final productProvider = StateNotifierProvider<ProductProvider, List<Product>>(
  //Cách 1
        (ref) {
      return ProductProvider();
    }
  //Cách 2
  //   (ref) => ProductProvider()
);