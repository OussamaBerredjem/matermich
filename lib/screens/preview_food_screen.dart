import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/chat_model.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/screens/add_product_screen.dart';
import 'package:matermich/screens/messages_screen.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/product_controller.dart';
import 'package:matermich/services/seller_product_controller.dart';
import 'package:matermich/services/update_product.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';

class PreviewFoodScreen extends StatefulWidget {
  int index;
  ProductInformation productInformation;
  PreviewFoodScreen({super.key,this.index=0,required this.productInformation});

  @override
  State<PreviewFoodScreen> createState() => _PreviewFoodScreenState();
}

class _PreviewFoodScreenState extends State<PreviewFoodScreen> {

  bool expand = false;
  late UpdateProduct updateProduct;


  @override
  void initState() {
    // TODO: implement initState
    if(!expand) {
      Future.delayed(const Duration(milliseconds: 30),(){
        setState(() {
        expand = true;
        });
      });
    }

   updateProduct = Get.put(UpdateProduct(productInformation: widget.productInformation),tag: "updateproduct");
   updateProduct.productInformation = widget.productInformation;
    super.initState();
  }

  final AccountController _accountController = Get.find(tag:"account");
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> isLiked() async{
    try {
      DocumentReference documentReference = _firestore.collection("users").doc(_accountController.information.value.uid).collection("wishlist").doc(widget.productInformation.uid);

      DocumentSnapshot doc = await documentReference.get();

      return doc.exists;

      
    } catch (e) {
      return false;
    }
  }

  ValueNotifier<bool> like = ValueNotifier<bool>(false);
  ValueNotifier<int> p = ValueNotifier(1);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: _accountController.information.value.role? [


          GetBuilder<SellerProductController>(
            tag:"product",
            builder: (controller) {
              return PopupMenuButton(itemBuilder: (ctx)=> widget.productInformation.price != "0"?[
              
                
                PopupMenuItem(child: const Row(
                  mainAxisSize:MainAxisSize.min,
                  children: [
                    Icon(Ionicons.pricetag_outline),
                    SizedBox(width:9),
                    Text("Discount"),
                  ],
                ),onTap: (){
               showDialog(context: context, builder: (context){
                       ValueNotifier<int> pro = ValueNotifier<int>(widget.productInformation.promotion);
                      return AlertDialog(
                        actions: [
                           TextButton(onPressed: () async{
                            await controller.addPromotion(pro.value, widget.productInformation);
                            Get.back();
                            Get.snackbar("Success", "Discount Of ${pro.value} save succcesfuly",backgroundColor: Colors.green.shade100,snackPosition: SnackPosition.BOTTOM);
                            setState(() {});
                          }, child: const Text("Save",style: TextStyle(color: Colors.green),)),
                          TextButton(onPressed: (){
                            Get.back();
                          }, child: const Text("Cancell",style: TextStyle(color: Colors.black54),)),
                          
                        ],
                        title:const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text("Discount",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                          ],
                        ),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){
                              if(pro.value >0){
                                pro.value = pro.value -5; 
                              }
                            }, icon: const Icon(Ionicons.remove_outline)),
                            const SizedBox(width: 7,),
                            ValueListenableBuilder(
                              valueListenable: pro,
                              builder: (context,value,child) {
                                return Text("$value%",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),);
                              }
                            ),
                            const SizedBox(width: 7,),
                             IconButton(onPressed: (){
                              if(pro.value <95){
                                
                                pro.value = pro.value +5; 
              
                              }
                            }, icon: const Icon(Ionicons.add)),
                          ],
                        ),
                      );
                      });
                },),
              
                PopupMenuItem(child: const Row(
                 mainAxisSize:MainAxisSize.min,
              
                  children: [
                    Icon(Ionicons.create_outline),
                    SizedBox(width:9),
                    Text("Edit"),
                  ],
                ),onTap: (){
                  Get.to(()=>AddProductScreen(product: widget.productInformation,edit: true,));
                },),
              
                PopupMenuItem(child: const Row(
                  mainAxisSize:MainAxisSize.min,
              
                  children: [
                    Icon(Ionicons.trash_outline,color: Colors.redAccent,),
                    SizedBox(width:9),
                    Text("Remove",style: TextStyle(color: Colors.redAccent,),),
                  ],
                ),onTap: (){
              showDialog(context: context, builder: (context)=>AlertDialog(
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                                    color: Colors.redAccent,
                                shape: BoxShape.circle
                            ),
                            child: const Icon(Icons.delete,color: Colors.white,size: 45,),
                          ),
                          const Text("Remove",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      content: const Text("are you sure remove this product ?"),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        ElevatedButton(onPressed: () async{
                          await controller.removeProduct(widget.productInformation);
                                
                        },style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("remove",style: TextStyle(color: Colors.white),),),
                        ElevatedButton(onPressed: (){
                          Get.back();
                        },style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade100,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("cancell",style: TextStyle(color: Colors.black54),),)
                                
                      ],
                    ));
                  
                },),
              ]:[
               PopupMenuItem(child: const Row(
                 mainAxisSize:MainAxisSize.min,
              
                  children: [
                    Icon(Ionicons.create_outline),
                    SizedBox(width:9),
                    Text("Edit"),
                  ],
                ),onTap: (){
                                Get.to(()=>AddProductScreen(product: widget.productInformation,edit: true,));

                },),
              
                PopupMenuItem(child: const Row(
                  mainAxisSize:MainAxisSize.min,
              
                  children: [
                    Icon(Ionicons.trash_outline,color: Colors.redAccent,),
                    SizedBox(width:9),
                    Text("Remove",style: TextStyle(color: Colors.redAccent,),),
                  ],
                ),onTap: (){
              showDialog(context: context, builder: (context)=>AlertDialog(
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                                                    color: Colors.redAccent,
                                shape: BoxShape.circle
                            ),
                            child: const Icon(Icons.delete,color: Colors.white,size: 45,),
                          ),
                          const Text("Remove",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                      content: const Text("are you sure remove this product ?"),
                      actionsAlignment: MainAxisAlignment.spaceEvenly,
                      actions: [
                        ElevatedButton(onPressed: () async{
                          await controller.removeProduct(widget.productInformation);
                                
                        },style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("remove",style: TextStyle(color: Colors.white),),),
                        ElevatedButton(onPressed: (){
                          Get.back();
                        },style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade100,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("cancell",style: TextStyle(color: Colors.black54),),)
                                
                      ],
                    ));
                  
                },),
              ]);
            }
          )
        ] : [
         
        ],
      ),
      body: Hero(
        tag: widget.index,
        child: GetBuilder<UpdateProduct>(
          tag: "updateproduct",
          builder: (updatecontroller) {
            return Material(
              child: ListView(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.03),
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.933,
                    height:MediaQuery.of(context).size.width*0.8,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(updatecontroller.productInformation.photo,fit: BoxFit.cover,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(updatecontroller.productInformation.categorie,style: GoogleFonts.roboto(fontWeight: FontWeight.w500,fontSize:15,color: Colors.black54),),
                        Text("Exp : ${updatecontroller.productInformation.expiration}",style: GoogleFonts.roboto(fontWeight: FontWeight.w400,fontSize:15,color: Colors.black54),),
            
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(updatecontroller.productInformation.name,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.06,fontWeight: FontWeight.bold),),
                        Visibility(
                          visible: !_accountController.information.value.role,
                          child: counter())
                      ],
                    ),
                  ),
            
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 12),
                    child: Text(updatecontroller.productInformation.desc),),
               
                  const Padding(
                    padding: EdgeInsets.only(left:12,right: 12,bottom: 10),
                    child: Row(
                      children: [
                        Icon(Ionicons.information_circle_outline),
                        SizedBox(width: 5,),
                        Text("Details",style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
                  ListTile(
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Customize the border radius
                  side: const BorderSide(
                      color: Colors.black26), // Customize the border side
                ),
                title: Text(widget.productInformation.seller.fullname,style: GoogleFonts.poppins(
            
                        fontWeight: FontWeight.w500),maxLines: 1,),
                subtitle: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   // Icon(Ionicons.time_outline,size: 17,),
                   // SizedBox(width: 5,),
                    Text("Contact Options")
                  ],
                ),
                leading: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(widget.productInformation.seller.image),fit: BoxFit.cover)
                    ),
                  ),
               
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                   GestureDetector(
                    onTap: (){
                      if(!_accountController.information.value.role){
                        Get.to(MessagesScreen(chatModel:ChatModel.fromOrder(user: widget.productInformation.seller)));
            
                      }
            
                    },
                     child: Container(
                                 height: 35,
                                 width: 35,
                                 padding: const EdgeInsets.all(4),
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(8),
                                   color: Colors.deepPurpleAccent
                                 ),
                                 child: const Icon(Ionicons.chatbubbles,color: Colors.white,size: 16,)),
                   ),
              
                    const SizedBox(width: 8,),
                    GestureDetector(
                      onTap: () async{
                            await EasyLauncher.call(number: widget.productInformation.seller.number);
            
                      },
                      child: Container(
                                  height: 35,
                                  width: 35,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.green
                                  ),
                                  child: const Icon(Ionicons.call,color: Colors.white,size: 16,)),
                    ),
              
                ],)
                ),
                const SizedBox(height: 8,),
                 ListTile(
                  onTap: ()async{
                        await _accountController.openMap(widget.productInformation.seller);
            
                  },
                tileColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12), // Customize the border radius
                  side: const BorderSide(
                      color: Colors.black26), // Customize the border side
                ),
                title: const Text("Restaurant Adress"),
                subtitle: Text(widget.productInformation.seller.location,
                    overflow: TextOverflow.fade,
                    maxLines: 4,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                leading: const Icon(Ionicons.location_outline),
                trailing: const Visibility(
                    visible: false,
                    child: Icon(Icons.keyboard_arrow_right)),
              ),
             
                   
                ],
              ),
            );
          }
        ),
      ),
      bottomNavigationBar: GetBuilder<UpdateProduct>(
        tag: "updateproduct",
        builder: (updatecontroller) {
          return Container(
            height:  80,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 15),
            child: AnimatedOpacity(
              opacity: expand?1:0,
              duration: const Duration(milliseconds: 1000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Price"),
                      ValueListenableBuilder(
                        valueListenable: p,
                        builder: (context,val,child) {
                          return Text("${int.parse(updatecontroller.productInformation.price) * val} DZD",style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.06,fontWeight: FontWeight.bold),);
                        }
                      ),
                    ],
                  ),
                   _accountController.information.value.role?const SizedBox():GetBuilder<ProductController>(
                    tag: "pro",
                     builder: (product) {
                       return ElevatedButton(
                              onPressed: () async {
                                widget.productInformation.quantite = p.value;
                                await product.addToCart(widget.productInformation);
                                Get.snackbar("success", "add to cart success",duration: const Duration(seconds: 2),backgroundColor: Colors.green.shade100);
                              },
                              style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all<Size>(Size(
                                      MediaQuery.of(context).size.width * 0.4,
                                      MediaQuery.of(context).size.height * 0.058)),
                                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12))),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(Colors.green)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Add to Cart",
                                      style: TextStyle(
                                          
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Icon(
                                    Ionicons.cart_outline,
                                    color: Colors.white,
                                  )
                                ],
                              ));
                     }
                   ),
              
                  
                ],
              ),
            ),
          );
        }
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: like,
        builder: (context,value,child) {
          return FutureBuilder<bool>(
            future: isLiked(),
            builder: (context, snapshot) {
              return  FloatingActionButton(
                backgroundColor: Colors.white70,
                onPressed: () async{
                  like.value = !like.value;
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.data!){
                    try {
                      DocumentReference documentReference =  _firestore.collection("users").doc(_accountController.information.value.uid).collection("wishlist").doc(widget.productInformation.uid);
                      documentReference.delete();
                    } catch (e) {
                    }
                  }else{
                    await _firestore.collection("users").doc(_accountController.information.value.uid).collection("wishlist").doc(widget.productInformation.uid).set(widget.productInformation.toMap(uids: widget.productInformation.uid));
                    setState(() {});
                  }
                  }
                  
                },
                child: snapshot.data??false? const Icon(Ionicons.heart,color: Colors.redAccent,):const Icon(Ionicons.heart_outline),
                );
            }
          );
        }
      ),
    );
  }

  Widget counter(){
      return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: false?Colors.transparent:Colors.black54
          ),
          child:  IgnorePointer(
            ignoring: false,
            child: StepperSwipe(
                withPlusMinus: true,
                withFastCount: true,
                withBackground: false,
                initialValue:1,
                speedTransitionLimitCount: 3, //Trigger count for fast counting
                onChanged: (int value){
                  p.value = value;
                  widget.productInformation.quantite = value;
                } ,
                firstIncrementDuration: const Duration(milliseconds: 250), //Unit time before fast counting
                secondIncrementDuration: const Duration(milliseconds: 100), //Unit time during fast counting
                direction: Axis.horizontal,
                dragButtonColor: Colors.green,
                    maxValue: 10,
                    minValue: 1,
                stepperValue: 1,
              ),
          ),
          
        ),
      ],
    );
 
    }
}