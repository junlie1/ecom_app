import 'package:ecom_tieuluan_app/controllers/product_controller.dart';
import 'package:ecom_tieuluan_app/provider/product_provider.dart';
import 'package:ecom_tieuluan_app/views/screens/nav_screen/widgets/header_widget.dart';
import 'package:ecom_tieuluan_app/views/screens/nav_screen/widgets/product_item_widget.dart';
import 'package:ecom_tieuluan_app/views/screens/nav_screen/widgets/reuseable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final productController = ProductController();
    try {
      final products = await productController.loadPopularProduct();
      ref.read(productProvider.notifier).setProduct(products); // Đẩy sản phẩm vào provider
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productProvider);

    // Kiểm tra xem sản phẩm có null hoặc rỗng
    if (products == null || products.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No products available'), // Hiển thị nếu không có sản phẩm
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(),
          const SizedBox(height: 10),
          ReusableTextWidget(title: "Tất cả sản phẩm", subtitle: "Mua ngay"),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Hiển thị 2 sản phẩm trên mỗi dòng
                crossAxisSpacing: 10, // Khoảng cách ngang giữa các cột
                mainAxisSpacing: 10, // Khoảng cách dọc giữa các hàng
                childAspectRatio: 0.7, // Tỷ lệ giữa chiều rộng và chiều cao của mỗi item
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductItemWidget(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}
