import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/ads_model.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/screens/search_screen.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/widgets/product_widget.dart';
import 'package:matermich/widgets/promosion_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final AccountController _controller = Get.find(tag:"account");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   // Get the current time
  DateTime now = DateTime.now();

  // Calculate the time 3 days ago
  late DateTime threeDaysAgo;

  @override
  void initState() {
    // TODO: implement initState
     threeDaysAgo = now.subtract(const Duration(days: 3));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
          length: _controller.information.value.role?3:4,
          child: NestedScrollView(
             headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return  [
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Hero(
                  tag: "search",
                  child: Material(
                    child: TextField(
                      readOnly: true,
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const SearchScreen()));
                      },
                      selectionHeightStyle: BoxHeightStyle.tight,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                        prefixIcon: const Icon(Ionicons.search,size: 18,),
                        hintText: "Search",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(20)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: TabBar(
                    isScrollable: true,
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.start,

                    overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
                    labelStyle: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.041),
                    unselectedLabelStyle: const TextStyle(color: Colors.grey),
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    tabs: _controller.information.value.role?
                    [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Tab(
                        child: Text("New",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                      ),
                    ),
              
                     Tab(
                       child: Text("Donate",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                     ),
                     Tab(
                       child: Text("Promotion",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                     ),
                  ]
                    : [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Tab(
                        child: Text("New",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                      ),
                    ),
                     Tab(
                       child: Text("Proximity",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                     ),
                     Tab(
                       child: Text("Donate",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                     ),
                     Tab(
                       child: Text("Promotion",style: GoogleFonts.roboto(fontWeight: FontWeight.bold),),
                     ),
                  ],),),
              ),
              
          
            
              
            ];
            },
            body: GetBuilder<AccountController>(
                  tag: "account",
              builder: (cont) {
                return TabBarView(
                  children: _controller.information.value.role?[
                 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firestore.collection("products").where("seller",isEqualTo: _controller.information.value.uid).where("timestamp",isGreaterThan: threeDaysAgo).snapshots(),
                   builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return  GridView.builder(
                    itemCount: 8,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: Skeletonizer(
                      child: ProductWidget(index: Random().nextInt(1000),productInformation: ProductInformation.Empty(),)),
                   ));
                    }else if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active){
                       List<ProductInformation> mlist = [];
                       snapshot.data?.docs.forEach((doc){
                        try {
                            mlist.add(ProductInformation.fromFirebase(doc.data()));
                
                        } catch (e) {
                        }
                       });
                  return mlist.isEmpty? const Center(child: Text("No New Product"),): GridView.builder(
                    itemCount:mlist.length,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: ProductWidget(ribon: "new",index: Random().nextInt(1000),productInformation: mlist[position],),
                   ));
                    }if(snapshot.hasError){
                    }
                
                    return const Center(child: Text("No New Product"),);
                   }
                   ),


                  /** Donate */
                        
                 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firestore.collection("products").where("seller",isEqualTo: _controller.information.value.uid).where("price",isEqualTo: "0").snapshots(),
                   builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return  GridView.builder(
                    itemCount: 8,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: Skeletonizer(
                      child: ProductWidget(index: Random().nextInt(1000),productInformation: ProductInformation.Empty(),)),
                   ));
                    }else if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active){
                       List<ProductInformation> mlist = [];
                       snapshot.data?.docs.forEach((doc){
                        try {
                            mlist.add(ProductInformation.fromFirebase(doc.data()));
                
                        } catch (e) {
                        }
                       });
                  return mlist.isEmpty? const Center(child: Text("No Donate Product"),):GridView.builder(
                    itemCount:mlist.length,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: ProductWidget(ribon: "Free",index: Random().nextInt(1000),productInformation: mlist[position],),
                   ));
                    }if(snapshot.hasError){
                    }
                
                    return const Center(child: Text("No Donate Product"),);
                   }
                   ),
                  /** Promotion */
                  
                 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firestore.collection("ads").where("seller",isEqualTo: _controller.information.value.uid).snapshots(),
                   builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return  ListView.builder(
                    itemCount: 8,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                   itemBuilder: (context,position)=>Skeletonizer(
                    child: ProductWidget(index: Random().nextInt(1000),productInformation: ProductInformation.Empty(),)));
                    }else if(snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active){
                       List<AdsModel> mlist = [];
                       snapshot.data?.docs.forEach((doc){
                        try {
                            mlist.add(AdsModel.fromFirebase(doc.data()));
                
                        } catch (e) {
                        }
                       });
                  return mlist.isEmpty? const Center(child: Text("No Promosion Product"),):ListView.builder(
                    itemCount:mlist.length,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                   itemBuilder: (context,position)=>PromosionWidget(adsModel: mlist[position]));
                    }if(snapshot.hasError){
                    }
                
                    return const Center(child: Text("No Discount Product"),);
                   }
                   ),
                ]:[
                 /** New */
                 FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future:  _firestore.collection("products").where("timestamp",isGreaterThan: threeDaysAgo).get(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      List<ProductInformation> list = [];
                      snapshot.data?.docs.forEach((value){
                        list.add(ProductInformation.fromFirebase(value.data()));
                      });
                     
                      return  list.isEmpty? const Center(
                      child: Text("No New Product"),
                    ):GridView.builder(
                    itemCount: list.length,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: ProductWidget(ribon: "new",index: Random().nextInt(1000),productInformation:list[position],),
                   ));
                    }
                    return GridView.builder(
                    itemCount: 8,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: Skeletonizer(
                      child: ProductWidget(index: Random().nextInt(1000),productInformation: ProductInformation.Empty(),)),
                   ));
                  }),


                /** proximity */

                
                 FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future:  _firestore.collection("products").where("latitude",isLessThanOrEqualTo: _controller.calculateLatLongRange()["maxLat"],isGreaterThanOrEqualTo: _controller.calculateLatLongRange()["minLat"]).where("longitude",isLessThanOrEqualTo: _controller.calculateLatLongRange()["maxLon"],isGreaterThanOrEqualTo: _controller.calculateLatLongRange()["minLon"]).get(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      List<ProductInformation> list = [];
                      int i = 1;
                      snapshot.data?.docs.forEach((value){
                        i++;
                        list.add(ProductInformation.fromFirebase(value.data()));
                      });
                     
                      return  list.isEmpty? const Center(
                      child: Text("No Proximity Product"),
                    ):GridView.builder(
                    itemCount: list.length,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: ProductWidget(index: Random().nextInt(1000),productInformation:list[position],),
                   ));
                    }
                    return const Center(
                      child: Text("No New Product"),
                    );
                  }),
                  /** Donate */
                
                 FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future:  _firestore.collection("products").where("price",isEqualTo: "0").get(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      List<ProductInformation> list = [];
                      snapshot.data?.docs.forEach((value){
                        list.add(ProductInformation.fromFirebase(value.data()));
                      });
                     
                      return  list.isEmpty? const Center(
                      child: Text("No Donate Product"),
                    ):GridView.builder(
                    itemCount: list.length,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 0.7),
                   itemBuilder: (context,position)=>Padding(
                     padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.018),
                     child: ProductWidget(ribon: "free",index: Random().nextInt(1000),productInformation:list[position],),
                   ));
                    }
                    return const Center(
                      child: Text("No Donate Product"),
                    );
                  }),
                  /** Promotion */
                    
                 
                 FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: _firestore.collection("ads").get(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      List<AdsModel> list = [];
                      snapshot.data?.docs.forEach((value){
                        list.add(AdsModel.fromFirebase(value.data()));
                      });
                     
                      return  list.isEmpty? const Center(
                      child: Text("No Promotion Product"),
                    ):ListView.builder(
                    itemCount: list.length,
                    padding:EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.01) ,
                   itemBuilder: (context,position)=>PromosionWidget(adsModel: list[position]));
                    }
                    return const Center(
                      child: Text("No Promotion Product"),
                    );
                  }),
                ],);
              }
            ),
            
          ),
        ),
        
    );
  }
}