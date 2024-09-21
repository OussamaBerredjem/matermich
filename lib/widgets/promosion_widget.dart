import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/ads_model.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/product_controller.dart';
import 'package:matermich/widgets/buyer_order_widget.dart';

import '../services/seller_product_controller.dart';

class PromosionWidget extends StatelessWidget {
  AdsModel adsModel;
  PromosionWidget({super.key, required this.adsModel});
  final AccountController _accountController = Get.find(tag: "account");
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(8),
     child: GestureDetector(
        onTap: () {},
        child: Stack(
          children: [
            Positioned(
              top: 2,
              bottom: 2,
              left: 2,
              right: 2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(adsModel.cover),
                    opacity: 0.8,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 15,
              right: 15,
              bottom: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                              width: MediaQuery.of(context).size.width*0.5,

                        child: Text(
                          
                          adsModel.name,
                          style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold,shadows: [
                Shadow( // Top-left shadow
                  offset: const Offset(-2.0, -2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Top-right shadow
                  offset: const Offset(2.0, -2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Bottom-right shadow
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Bottom-left shadow
                  offset: const Offset(-2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.5,
                        child: Text(adsModel.desc,style: TextStyle(color: Colors.white,fontSize: 20,shadows: [
                Shadow( // Top-left shadow
                  offset: const Offset(-2.0, -2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Top-right shadow
                  offset: const Offset(2.0, -2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Bottom-right shadow
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Bottom-left shadow
                  offset: const Offset(-2.0, 2.0),
                  blurRadius: 3.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],),softWrap: true,maxLines: 2,
                        overflow: TextOverflow.fade,))
                    ],
                  ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: NetworkImage(adsModel.photo),fit: BoxFit.cover)
                  ),
                )
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 15,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${adsModel.price} DZD",
                    style: TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold,shadows: [
                Shadow( // Top-left shadow
                  offset: const Offset(-2.0, -2.0),
                  blurRadius: 4.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Top-right shadow
                  offset: const Offset(2.0, -2.0),
                  blurRadius: 4.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Bottom-right shadow
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow( // Bottom-left shadow
                  offset: const Offset(-2.0, 2.0),
                  blurRadius: 4.0,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],),

              
                  ),
                  _accountController.information.value.role? GetBuilder<SellerProductController>(
            tag: "product",
            builder: (controller) {
              return ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),onPressed: (){
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
                     await controller.removeAds(adsModel);
                            
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("remove",style: TextStyle(color: Colors.white),),),
                    ElevatedButton(onPressed: (){
                      Get.back();
                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade100,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text("cancell",style: TextStyle(color: Colors.black54),),)
                            
                  ],
                ));
              },child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Delete  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          Icon(Icons.delete,color: Colors.white,size: 18,)
                        ],
                      ),);
            }
          ):ElevatedButton(onPressed: (){
                        showModalBottomSheet(context: context, builder: (context)=>Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 3,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(12)
                              ),
                            ),
                            BuyerOrderWidget(productInformation: adsModel.toProduct(), onCount: (value){}),
                            const SizedBox(height: 10,),
                            ValueListenableBuilder(
                              valueListenable: _isLoading,
                              builder: (context,val,child) {
                                return ElevatedButton(
                                                      onPressed: () async {
                                                        _isLoading.value = true;
                                                       ProductController productController = Get.find(tag:"pro");
                                                        await productController.addToCart(adsModel.toProduct());
                                                        _isLoading.value = false;
                                                        Get.snackbar("Success", "product add to cart sucessfully",backgroundColor: Colors.green.shade100);
                                                        Navigator.of(context).pop();
                                                      },
                                                      style: ButtonStyle(
                                                          maximumSize: WidgetStateProperty.all<Size>(Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  MediaQuery.of(context).size.height * 0.06)),
                                   minimumSize: WidgetStateProperty.all<Size>(Size(
                                  MediaQuery.of(context).size.width * 0.9,
                                  MediaQuery.of(context).size.height * 0.06)),
                                                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                                                          backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.green)),
                                                      child:val? const SizedBox(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.white,),):Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Text("Order Now",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19,
                                      color: Colors.white)),
                                                          const SizedBox(
                                width: 25,
                                                          ),
                                                          const Icon(
                                CupertinoIcons.arrow_right,
                                color: Colors.white,
                                                          )
                                                        ],
                                                      ));
                              }
                            ),
                      
                      const SizedBox(height: 15,)
                                
                          ],
                        ));
                      },style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )), 
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Order now  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                          Icon(Ionicons.bag_handle,color: Colors.white,size: 18,)
                        ],
                      ),)
                    
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
