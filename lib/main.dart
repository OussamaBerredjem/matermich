import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:matermich/screens/buyer/buyer_home_screen.dart';
import 'package:matermich/screens/chat_screen.dart';
import 'package:matermich/screens/location_picker.dart';
import 'package:matermich/screens/location_screen.dart';
import 'package:matermich/screens/login_screen.dart';
import 'package:matermich/screens/personal_screen.dart';
import 'package:matermich/screens/seller/seller_home_screen.dart';
import 'package:matermich/screens/signup_screen.dart';
import 'package:matermich/screens/wishlist_screen.dart';

import 'services/account_controller.dart';


void main() async{
  try {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AccountController accountController = Get.put(tag: "account",AccountController());
  await accountController.initApp();
  
  runApp(MyApp());

  } catch (e) {
  }
  
}



class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AccountController _accountController = Get.find(tag: "account");
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    String inital = "/login_screen";

    if(_accountController.islogin){
      if (_accountController.information.value.role) {
        inital = "/home_seller";
      } else {
        inital = "/home_buyer";

      }
    }
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white70, // Status bar color
      statusBarIconBrightness: Brightness.light, // White icons for dark background
    ));

    return GetMaterialApp(
      defaultTransition: Transition.cupertino,
      initialRoute: inital,
      getPages: [
        GetPage(name: "/home_buyer", page: ()=>const BuyerHomeScreen()),
        GetPage(name: "/home_seller", page: ()=>const SellerHomeScreen()),
        GetPage(name: "/location_picker", page: ()=>LocationPicker()),
        GetPage(name: "/location_screen", page: ()=>LocationScreen()),
        GetPage(name: "/wishlist_screen", page: ()=>const WishlistScreen()),
        GetPage(name: "/personal_screen", page: ()=>const PersonalScreen()),
        GetPage(name: "/chat_screen", page: ()=>const ChatScreen()),
        GetPage(name: "/signup_screen", page: ()=>const SignupScreen()),
        GetPage(name: "/login_screen", page: ()=>const LoginScreen()),
        ],
        
      debugShowCheckedModeBanner: false,
      
    );
  }

}