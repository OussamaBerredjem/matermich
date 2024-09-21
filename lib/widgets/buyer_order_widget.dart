import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/product_controller.dart';
import 'package:stepper_counter_swipe/stepper_counter_swipe.dart';

class BuyerOrderWidget extends StatelessWidget {
  bool stop;
  void Function(int) onCount;
  ProductInformation productInformation;
  BuyerOrderWidget({super.key,this.stop = false,required this.productInformation,required this.onCount});
  late ValueNotifier<int> p = ValueNotifier(productInformation.quantite);

  @override
  Widget build(BuildContext context) {
   
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
         Container(
                   height: MediaQuery.of(context).size.width*0.28,
                    width: MediaQuery.of(context).size.width*.28,
                      margin: const EdgeInsets.only(left: 14,right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image:NetworkImage(productInformation.photo),
                          fit: BoxFit.fill
                    )
                      ),
                      
                    ),
                   
         Container(
           padding: const EdgeInsets.symmetric(vertical: 1.0),
           height: MediaQuery.of(context).size.width*0.3,
           width: !stop ? MediaQuery.of(context).size.width*0.65:MediaQuery.of(context).size.width*0.6,
           child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !stop?Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(productInformation.name,style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.06,color: Colors.black),),
                      GestureDetector(
                        onTap: () async{
                          ProductController().removeFromCart(productInformation);
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.delete,color: Colors.redAccent,),
                        ),
                      ),
                    ],
                  ): Text(productInformation.name,style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.06,color: Colors.black),),

                  Text(productInformation.seller.fullname),
      
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder(
                    valueListenable: p,
                    builder: (context,value,child){

                       String u = "${p.value*int.parse(productInformation.price)} DZD";
                        if(int.parse(productInformation.price)== 0){
                           u = "Donate";
                        }
                      
                      return Text(u,style: TextStyle(fontSize:  MediaQuery.of(context).size.width*0.06,fontWeight: FontWeight.bold),);}),
                 
                   Visibility(
                    visible: !productInformation.empty,
                    child: counter()
                  )
                ],
              ),
           
            ],
           ),
         )
        ],
      ),
    );
    }

    Widget counter(){
      return !stop? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){
                            if(p.value >1){
                              p.value = p.value -1; 
                              productInformation.quantite = p.value;
                            }
                          }, icon: const Icon(Ionicons.remove_outline)),
                          ValueListenableBuilder(
                            valueListenable: p,
                            builder: (context,value,child) {
                              return Text("$value",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),);
                            }
                          ),
                           IconButton(onPressed: (){
                            if(p.value <10){
                              
                              p.value = p.value +1; 
                              productInformation.quantite = p.value;

            
                            }
                          }, icon: const Icon(Ionicons.add)),
                        ],
                      )
                   :Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: stop?Colors.transparent:Colors.black54
          ),
          child:  IgnorePointer(
            ignoring: stop,
            child: StepperSwipe(
                withPlusMinus: !stop,
                withFastCount: true,
                withBackground: false,
                initialValue: p.value,
                speedTransitionLimitCount: 3, //Trigger count for fast counting
                onChanged: (int value){ 
                  p.value = value;
                  productInformation.quantite = value;
                  onCount(value);
                  },
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