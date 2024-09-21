import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/screens/preview_food_screen.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/product_controller.dart';
import 'package:ribbon_widget/ribbon_widget.dart';

class ProductWidget extends StatefulWidget {
  String? ribon;
  int index;
  ProductInformation productInformation;
  ProductWidget({super.key,this.ribon,this.index=0,required this.productInformation});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {

    final AccountController _accountController = Get.find(tag: "account");


  @override
  Widget build(BuildContext context) {
    String u = "${widget.productInformation.price} DZD";
    if(widget.productInformation.price == "0"){
      u = "Donate";
    }
    return Hero(
      tag:widget.index,

      child: Material(
        child: GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PreviewFoodScreen(index:widget.index,productInformation:widget.productInformation)));
        },
        child: widget.ribon!=null? Ribbon(
          nearLength: 20,
          farLength: 60,
          color: Colors.redAccent,
          titleStyle: const TextStyle(color: Colors.yellow,fontSize: 20),
          title: widget.ribon??'',
          child: Container(
            height: MediaQuery.of(context).size.height*0.33,
            width: MediaQuery.of(context).size.width * 0.44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100
            ),
            child: Stack(
              children: [
              
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width*0.4,
                        width: MediaQuery.of(context).size.width*4,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image:NetworkImage(widget.productInformation.photo),
                            fit: BoxFit.fill
                      )
                        ),
                        
                      ),
                      Text(widget.productInformation.name,style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.045),),
                      Text(widget.productInformation.seller.fullname),
                     
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                      child:_accountController.information.value.role? Text(u,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),)
                      :Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                                  Text(u,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                                  IconButton(onPressed: (){}, icon: const Icon(Ionicons.add,color: Colors.white70,),style: IconButton.styleFrom(backgroundColor: Colors.green),)
          
                        ],
                      ),)                 
                    ],
                  ),
                  ),
                 
              ],
            ),
          ),
        ):Container(
            height: MediaQuery.of(context).size.height*0.33,
            width: MediaQuery.of(context).size.width * 0.44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100
            ),
            child: Stack(
              children: [
              
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width*0.4,
                        width: MediaQuery.of(context).size.width*4,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image:NetworkImage(widget.productInformation.photo),
                            fit: BoxFit.fill
                      )
                        ),
                        
                      ),
                      Text(widget.productInformation.name,style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.045),),
                      Text(widget.productInformation.seller.fullname),
                     
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                      child:_accountController.information.value.role? Text(u,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),)
                      :Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                                  Text(u,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                                 
                                  _accountController.information.value.role?const SizedBox():GetBuilder<ProductController>(
                                    tag: "pro",
                                    builder: (productController) {
                                      return Visibility(visible: !_accountController.information.value.role,child: IconButton(onPressed: () async{
                                        await productController.addToCart(widget.productInformation);
                                      }, icon: const Icon(Ionicons.add,color: Colors.white70,),style: IconButton.styleFrom(backgroundColor: Colors.green),));
                                    }
                                  )
          
                        ],
                      ),)                 
                    ],
                  ),
                  ),
                 
              ],
            ),
          )),
      ),
    );
  }
}