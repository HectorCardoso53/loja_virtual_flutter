import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/home/home_screen.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:loja_virtual/screens/orders/components/order_tile.dart';
import 'package:loja_virtual/screens/orders/orders_screen.dart';
import 'package:loja_virtual/screens/products/Products_screen.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {


    return Provider(
      create: (_)=> PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (context,userManager,child){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(),
              ProductsScreen(),
              OrdersScreen(),
              Scaffold(
                drawer: CustomDrawer(),
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 4, 125, 141),
                  title: Text('Home4',style: TextStyle(color: Colors.white),),
                ),
              ),
              if(userManager.adminEnabled)
                ...[
                  AdminUsersScreen(),
                  Scaffold(
                    drawer: CustomDrawer(),
                    appBar: AppBar(
                      backgroundColor: const Color.fromARGB(255, 4, 125, 141),
                      title: Text('Pedidos',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ]
            ],
          );
        },
      ),
    );
  }
}
