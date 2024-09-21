import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/screens/accuel_screen.dart';
import 'package:matermich/screens/explore_screen.dart';
import 'package:matermich/screens/orders_screen.dart';
import 'package:matermich/screens/profile_screen.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/product_controller.dart';
import 'dart:math';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  int _index = 0;
  final List<Widget> _items = [
    const AccuelScreen(),
    const ExploreScreen(),
    const OrdersScreen(),
    const ProfileScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  final AccountController _accountController = Get.find(tag: "account");
  final ProductController _productController =
      Get.put(tag: "pro", ProductController());
  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) {
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
                      Text(
                        "Delivery Address",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const Icon(
                        Ionicons.chevron_forward_outline,
                        size: 20,
                        color: Colors.red,
                      )
                    ],
                  ),
                  subtitle: GetBuilder<AccountController>(
                      tag: "account",
                      builder: (controller) {
                        return Text(
                          _accountController.information.value.location,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        );
                      }),
                  trailing: GetBuilder<AccountController>(
                      tag: "account",
                      builder: (controller) {
                        return GestureDetector(
                          onTap: () async {
                            await AwesomeNotifications().initialize(
                              debug: true,
                              null,
                              [
                                NotificationChannel(
                                  channelKey: 'news',
                                  channelName: 'News Channel',
                                  channelDescription:
                                      'Channel for news notifications',
                                  defaultColor: Colors.teal,
                                  ledColor: Colors.teal,
                                ),
                              ],
                            );

                            await AwesomeNotifications().createNotification(
                              content: NotificationContent(
                                id: Random().nextInt(100),
                                largeIcon: "asset://assets/icons/test_burger.png",
                                channelKey: 'news',
                                notificationLayout: NotificationLayout.Messaging,
                                title: "Warning",
                                body:
                                    "There is not much time left until Cheeze burger , click for more details",
                              ),
                            );
                          },
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(_accountController
                                        .information.value.image),
                                    fit: BoxFit.cover)),
                          ),
                        );
                      }),
                ),
              )),
          body: IndexedStack(
            index: _index,
            children: _items,
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
                      ? BootstrapIcons.house_fill
                      : BootstrapIcons.house),
                  label: "Home"),
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
                  icon:
                      Icon(_index == 3 ? Icons.person : CupertinoIcons.person),
                  label: "Account")
            ],
          )),
    );
  }
}
