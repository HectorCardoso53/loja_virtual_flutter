import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admin_users_manager.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/products_manager.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/address/address_screen.dart';
import 'package:loja_virtual/screens/cart/cart_screem.dart';
import 'package:loja_virtual/screens/checkout/checkout_screen.dart';
import 'package:loja_virtual/screens/confirmation/confirmation_screen.dart';
import 'package:loja_virtual/screens/edit_product/edit_product_screem.dart';
import 'package:loja_virtual/screens/login/login_screen.dart';
import 'package:loja_virtual/screens/orders/orders_screen.dart';
import 'package:loja_virtual/screens/product/product_screen.dart';
import 'package:loja_virtual/screens/select_product/select_product_screen.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'models/admin_orders_manager.dart';
import 'models/order.dart';
import 'screens/base/base_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => ProductsManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_)=> StoresManager(),
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (context) => CartManager(),
          lazy: false,
          update: (context, userManager, cartManager) =>
              (cartManager ?? CartManager())..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) {
            if (userManager.user != null) {
              return (ordersManager ?? OrdersManager())
                ..updateUser(userManager.user!);
            }
            return ordersManager ??
                OrdersManager(); // Retorna um novo OrdersManager se ordersManager for nulo
          },
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              (adminUsersManager ?? AdminUsersManager())
                ..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) =>
              (adminOrdersManager ?? AdminOrdersManager())
                ..updateAdmin(adminEnable: userManager.adminEnabled),
        ),
      ],
      child: MaterialApp(
        title: 'Loja Virtual',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.white, // Define a cor do ícone do Drawer aqui
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(
                builder: (context) => LoginScreen(),
              );
            case '/edit_product':
              return MaterialPageRoute(
                builder: (context) => EditProductScreen(
                  product: settings.arguments as Product?,
                ),
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (context) => SignupScreen(),
              );
            case '/product':
              return MaterialPageRoute(
                builder: (context) =>
                    ProductScreen(settings.arguments as Product),
              );
            case '/cart':
              return MaterialPageRoute(
                  builder: (context) => CartScreem(), settings: settings);
            case '/select_product':
              return MaterialPageRoute(
                builder: (context) => SelectProductScreen(),
              );
            case '/address':
              return MaterialPageRoute(
                builder: (context) => AddressScreen(),
              );
            case '/checkout':
              return MaterialPageRoute(
                builder: (context) => CheckoutScreen(),
              );
            case '/confirmation':
              return MaterialPageRoute(
                builder: (context) =>
                    ConfirmationScreen(settings.arguments as Orders),
              );
            case '/':
            default:
              return MaterialPageRoute(
                  builder: (context) => BaseScreen(), settings: settings);
          }
        },
      ),
    );
  }
}
