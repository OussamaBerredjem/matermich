import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/order_information.dart';
import 'package:matermich/models/order_status.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/product_controller.dart';
import 'package:matermich/widgets/buyer_order_widget.dart';
import 'package:matermich/widgets/order_bottomsheet.dart';
import 'package:matermich/widgets/skeletonizer_order.dart';
import 'package:matermich/widgets/status_buyer_order_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersBuyerScreenState();
}

class _OrdersBuyerScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 4, vsync: this);
    controller.addListener(() {
      setState(() {
        index = controller.index;
      });
    });
    super.initState();
  }

List<ProductInformation> list =[];
List<int> price = [0];
List<int> tax = [0];

late OrderInformation _orderInformation;
final AccountController _accountController = Get.find(tag: "account");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
        bottom: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            dividerHeight: 0,
            overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
            labelStyle: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.038),
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            indicatorPadding:
                const EdgeInsets.only(left: 4, top: 8, bottom: 8, right: 4),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20)),
            controller: controller,
            tabs: const [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Ionicons.bag_outline,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Cart"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.alarm,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Waitting"),
                  ],
                ),
              ),
              Tab(
                
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Accepted"),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Ionicons.checkmark_done,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Completed"),
                  ],
                ),
              ),
            ]),
      ),
      body: GetBuilder<ProductController>(
        tag: "pro",
        builder: (productController) {
          return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:FirebaseFirestore.instance.collection("users").doc(_accountController.information.value.uid).collection("cart").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    
                    list.clear();
                    try{
                    if(snapshot.data != null){
                    list.clear();
                    for (var d in snapshot.data!.docs) {
                      list.add(ProductInformation.fromFirebase(d.data()));
                    }
                    }
                    }catch(e){
                    }
                   

                     _orderInformation = OrderInformation(products: list, userInformation: _accountController.information.value, status: OrderStatus.wait);
                   
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 9,
                          child: list.isEmpty?const Center(child: Text("No Products in cart"),): ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context,position)=> BuyerOrderWidget(productInformation: list[position],onCount: (count){
                            },),
                          
                          ),
                        ),

                        Visibility(
                visible: index == 0 && list.isNotEmpty,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                    child: ElevatedButton(
                          onPressed: () async {
                            _orderInformation.totals();
                            showModalBottomSheet(
                                isDismissible: true,
                                isScrollControlled: true,
                                enableDrag: true,
                                context: context,
                                builder: (context){ 
                                  return OrderBottomsheet(information: _orderInformation,);
                              });
                          },
                          style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all<Size>(Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  MediaQuery.of(context).size.height * 0.05)),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.green)),
                          child: Text("Checkout",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  color: Colors.white)))
                    
                     ,
                  ),
              )
            
                      ],
                    );
                  }else if(snapshot.connectionState == ConnectionState.done && !snapshot.hasData){
                    return const Center(child: Text("No Products in Cart"),);
                  }
                  return Skeletonizer(
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        BuyerOrderWidget(productInformation: ProductInformation.Empty(),onCount: (count){},),
                        BuyerOrderWidget(productInformation: ProductInformation.Empty(),onCount: (count){},),
                        BuyerOrderWidget(productInformation: ProductInformation.Empty(),onCount: (count){},),
                      ],
                    ),
                  );
                }
              ),
              StreamBuilder<List<OrderInformation>>(
                stream: productController.getStatusOrders(OrderStatus.wait),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return snapshot.data!.isEmpty?const Center(child: Text("No Waitting Orders"),):ListView.builder(
                      itemCount: snapshot.data?.length??0,
                      itemBuilder: (context,position) {
                        return StatusBuyerOrderWidget(waitting: true,seller: false,information: snapshot.data![position],);
                      }
                    );
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Skeletonizer(
                      child: SkeletonizerOrder()
                      );
                  }
                 return const Center(child: Text("No Waitting Orders"),);
                }
              ),
              StreamBuilder<List<OrderInformation>>(
                stream: productController.getStatusOrders(OrderStatus.accept),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return snapshot.data!.isEmpty?const Center(child: Text("No Accepted Orders"),):ListView.builder(
                      itemCount: snapshot.data?.length??0,
                      itemBuilder: (context,position) {
                        return StatusBuyerOrderWidget(waitting: true,accept: true,seller: false,information: snapshot.data![position],);
                      }
                    );
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Skeletonizer(
                      child: SkeletonizerOrder()
                      );
                  }
                 return const Center(child: Text("No Accept Orders"),);
                }
              ),
               StreamBuilder<List<OrderInformation>>(
                stream: productController.getStatusOrders(OrderStatus.complet),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return snapshot.data!.isEmpty?const Center(child: Text("No Completed Orders"),):ListView.builder(
                      itemCount: snapshot.data?.length??0,
                      itemBuilder: (context,position) {
                        return StatusBuyerOrderWidget(waitting: true,complet: true,seller: false,information: snapshot.data![position],);
                      }
                    );
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return const Skeletonizer(
                      child: SkeletonizerOrder()
                      );
                  }
                 return const Center(child: Text("No Complet Orders"),);
                }
              ),
            ],
          );
        }
      ),
      
          
    );
  }

  int GetPrice(){
    return price.first;
  }
}
