import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/order_information.dart';
import 'package:matermich/models/order_status.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/seller_product_controller.dart';
import 'package:matermich/widgets/skeletonizer_order.dart';
import 'package:matermich/widgets/status_buyer_order_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SellerOrdersScreen extends StatefulWidget {
  const SellerOrdersScreen({super.key});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    // TODO: implement initState
    controller = TabController(length: 3, vsync: this);
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
      body: GetBuilder<SellerProductController>(
        tag: "product",
        builder: (productController) {
          return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
               StreamBuilder<List<OrderInformation>>(
                stream: productController.getStatusOrders(OrderStatus.wait),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    return snapshot.data!.isEmpty?const Center(child: Text("No Waitting Orders"),): ListView.builder(
                      itemCount: snapshot.data?.length??0,
                      itemBuilder: (context,position) {
                        return StatusBuyerOrderWidget(waitting: true,seller: true,information: snapshot.data![position],);
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
                        return StatusBuyerOrderWidget(waitting: false,accept: true,seller: true,information: snapshot.data![position],);
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
                        return StatusBuyerOrderWidget(complet: true,seller: true,information: snapshot.data![position],);
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
