import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/chat_model.dart';
import 'package:matermich/models/order_information.dart';
import 'package:matermich/models/order_status.dart';
import 'package:matermich/screens/messages_screen.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/order_status_services.dart';
import 'package:matermich/services/product_controller.dart';
import 'package:matermich/services/send_notification.dart';

class OrderBottomsheet extends StatefulWidget {
  bool complete, waitting,seller,accept;
  OrderInformation information;

  OrderBottomsheet({super.key, this.complete = false, this.waitting = false,this.seller = false,this.accept=false,required this.information});

  @override
  State<OrderBottomsheet> createState() => _OrderBottomsheetState();
}

class _OrderBottomsheetState extends State<OrderBottomsheet> {
  AccountController user = Get.find(tag:'account');



  final ProductController _productController = ProductController();
  OrderStatusServices services = OrderStatusServices();
  bool _isLodaing = false;
  bool _cancell = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.waitting || widget.complete
              ? const Divider()
              : Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.35,
                      vertical: 5),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 3,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20)),
                ),
          const SizedBox(
            height: 8,
          ),
          Text("Order Summary",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 21)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 0.5, color: Colors.black26),
                color: Colors.green.shade100.withOpacity(.4)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal", style: TextStyle(fontSize: 17.5)),
                    Text("${widget.information.subtotal} DZD", style: const TextStyle(fontSize: 17.5))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tax",
                      style: TextStyle(fontSize: 17.5),
                    ),
                    Text("${widget.information.tax} DZD", style: const TextStyle(fontSize: 17.5))
                  ],
                ),
                const Divider(
                  color: Colors.black54,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 18)),
                    Text("${widget.information.total} DZD",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 18))
                  ],
                ),
              ],
            ),
          ),
          Text("Information",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 21)),
          
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: widget.waitting || widget.complete || widget.accept,
            child: ListTile(
              tileColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12), // Customize the border radius
                side: const BorderSide(
                    color: Colors.black26), // Customize the border side
              ),
              title: Text(widget.seller? widget.information.userInformation.fullname:widget.information.products.first.seller.fullname,style: GoogleFonts.poppins(
            
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
                    image: DecorationImage(image: NetworkImage(widget.seller? widget.information.userInformation.image:widget.information.products.first.seller.image),fit: BoxFit.cover)
                  ),
                ),
             
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                 GestureDetector(
                  onTap: (){
                    Get.to(MessagesScreen(chatModel: widget.seller?ChatModel.fromOrder(user: widget.information.userInformation) : ChatModel.fromOrder(user: widget.information.products.first.seller)));
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
                        await EasyLauncher.call(number: widget.information.products.first.seller.number);

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
          ),
       
          const SizedBox(
            height: 8,
          ),
          ListTile(
            onTap: () async{
              await user.openMap(user.information.value);
            },
            tileColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Customize the border radius
              side: const BorderSide(
                  color: Colors.black26), // Customize the border side
            ),
            title: const Text("Delivery Adress"),
            subtitle: Text(user.information.value.location,
                maxLines: 4,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 17)),
            leading: const Icon(Ionicons.location_outline),
            trailing: Visibility(
                visible: !widget.waitting && !widget.complete,
                child: const Icon(Icons.keyboard_arrow_right)),
          ),
          const SizedBox(
            height: 8,
          ),
          ListTile(
            tileColor: Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Customize the border radius
              side: const BorderSide(
                  color: Colors.black26), // Customize the border side
            ),
            title: const Text("Payment Methode"),
            subtitle: Text("Cash",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 17)),
            leading: const Icon(Ionicons.cash_outline),
            trailing: Visibility(
                visible: !widget.waitting && !widget.complete,
                child: const Icon(Icons.keyboard_arrow_right)),
          ),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: widget.seller && widget.waitting && !widget.accept && !widget.complete,
            child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLodaing = true;
                      });
                      await services.updateStatus(widget.information.id, OrderStatus.accept);
                      await SendNotification().sendNotification(uid: widget.information.userInformation.uid, title: "Order Accept", body: "you Order ${widget.information.id.substring(0,5)} has been Accepted");
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
                    child:_isLodaing? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(color: Colors.white,),
                    ):const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Accept",
                            style: TextStyle(
                                
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white)),
                        SizedBox(
                          width: 25,
                        ),
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      ],
                    )),
        
            ),

           Visibility(
            visible: widget.waitting && widget.accept && !widget.complete,
            child: ElevatedButton(
                    onPressed: () async {
                       setState(() {
                        _isLodaing = true;
                      });
                      await services.updateStatus(widget.information.id, OrderStatus.complet);
                      user.information.value.role? await SendNotification().sendNotification(uid: widget.information.userInformation.uid, title: "Order Complet", body: "${user.information.value.fullname} complet your order"):await SendNotification().sendNotification(uid: widget.information.products.first.seller.uid, title: 'Order Completed', body: '${user.information.value.fullname} completed his order');

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
                    child: _isLodaing? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(color: Colors.white,),
                    ):const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Complet",
                            style: TextStyle(
                                
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.white)),
                        SizedBox(
                          width: 25,
                        ),
                        Icon(
                          Ionicons.checkmark_done,
                          color: Colors.white,
                        )
                      ],
                    )),
        
            ),
         

          Visibility(
            visible: !widget.complete,
            child: widget.waitting || widget.accept
                ? OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.9,
                          MediaQuery.of(context).size.height * 0.05),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1, color: Colors.redAccent.withOpacity(.8)),
                        borderRadius: BorderRadius.circular(
                            12), // Change this value for a different radius
                      ),
                    ),
                    onPressed: () async{
                       setState(() {
                        _cancell = true;
                      });
                      await services.cancellOrder(widget.information.id);
                      user.information.value.role? await SendNotification().sendNotification(uid: widget.information.userInformation.uid, title: "Order Cancelled", body: "${user.information.value.fullname} Deny your order"):await SendNotification().sendNotification(uid: widget.information.products.first.seller.uid, title: 'Order Cancelled', body: '${user.information.value.fullname} cancell his order');

                    },
                    child:_cancell? const SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(color: Colors.black38,),
                    ): Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cancell",
                          style: TextStyle(
                              color: Colors.black
                                  .withOpacity(.6)
                                  .withOpacity(.81),
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                        const SizedBox(width: 25,),
                        Icon(
                          Icons.close,
                          color: Colors.black.withOpacity(.6),
                          size: 20,
                        )
                      ],
                    ))
                : ElevatedButton(
                    onPressed: () async{

                      await _productController.checkout(widget.information);
                      Get.back();
                      Get.snackbar("Success", "your order is in wait now",backgroundColor: Colors.green.shade100,snackPosition: SnackPosition.BOTTOM);

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
                    child:_isLodaing? const SizedBox(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.white,),):Row(
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
                    )),
          ),
        ],
      ),
    );
  }
}
