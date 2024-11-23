import 'package:ecom_tieuluan_app/views/screens/nav_screen/account_screen.dart';
import 'package:ecom_tieuluan_app/views/screens/nav_screen/cart_screen.dart';
import 'package:ecom_tieuluan_app/views/screens/nav_screen/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  List<Widget> _page = [
    HomeScreen(),
    CartScreen(),
    AccountScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          currentIndex: _pageIndex,
          onTap: (value) {
            //thay đổi giá trị của _pageIndex và
            //gọi setState() để cập nhật giao diện.
            setState(() {
              _pageIndex = value;
            });
          },
          type: BottomNavigationBarType.fixed ,
          items: [
            BottomNavigationBarItem(
                icon: Image.asset("assets/icons/home.png",width: 30,),
                label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Image.asset("assets/icons/cart.png",width: 30,),
                label: "Cart"
            ),
            BottomNavigationBarItem(
                icon: Image.asset("assets/icons/user.png",width: 30,),
                label: "Account"
            ),
          ]),
      body: _page[_pageIndex],
    );
  }
}
