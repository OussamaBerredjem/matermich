import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/screens/accuel_screen.dart';
import 'package:matermich/screens/explore_screen.dart';
import 'package:matermich/screens/profile_screen.dart';
import 'package:matermich/screens/seller/seller_orders_screen.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/seller_product_controller.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<SellerHomeScreen> {
  int _index = 0;
  final List<Widget> _items = [
    const AccuelScreen(),
    const ExploreScreen(),
    const SellerOrdersScreen(),
    const ProfileScreen()
  ];

    final AccountController _accountController = Get.find(tag:"account");
@override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

    final SellerProductController _productController = Get.put(tag: "product",SellerProductController());


  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvoked: (didpop){
        Get.dialog(const Text("where are u going"));
      },
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 60),
            child: Padding(
              padding: const EdgeInsets.only(top: 27.0),
              child: ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Restaurant Address",style: GoogleFonts.roboto(fontWeight: FontWeight.bold,color: Colors.black87),),
                    const SizedBox(width: 4,),
                    const Icon(Ionicons.chevron_forward_outline,size: 20,color: Colors.red,)
                  ],
                ),
                subtitle: GetBuilder<AccountController>(
                  tag: "account",
                  builder:(controller) {
                    return Text(_accountController.information.value.location,maxLines: 1,);
                  }
                ),
                trailing:GetBuilder<AccountController>(
                  tag: "account",
                  builder:(controller) {
                    return Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(_accountController.information.value.image),fit: BoxFit.cover)
                      ),
                    );
                  }
                ),
              ),
            )
            ),
        body:GetBuilder<AccountController>(
          tag: "account",
          builder: (cont) {
            return IndexedStack(
              index: _index,
              children: _items,
            );
          }
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _index,
            onTap: (position) {
              setState(() {
                _index = position;
              });
            },
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            fixedColor: Colors.green,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(_index == 0
                      ? Ionicons.fast_food
                      : Ionicons.fast_food_outline),
                  label: "Products"),
              BottomNavigationBarItem(
                  icon: Icon(_index == 1
                      ? Ionicons.search_sharp
                      : Ionicons.search_outline),
                  label: "Explore"),
      
              BottomNavigationBarItem(
                  icon: Icon(_index == 2
                      ? Ionicons.bag_handle_sharp
                      : Ionicons.bag_handle_outline),
                  label: "Orders"),
      
              BottomNavigationBarItem(
                  icon: Icon(_index == 3 ? Icons.person : CupertinoIcons.person),
                  label: "Account")
            ],
          )
      ),
    );
  }
}