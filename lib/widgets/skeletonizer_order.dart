import 'package:flutter/material.dart';
import 'package:matermich/models/order_information.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/widgets/buyer_order_widget.dart';
import 'package:matermich/widgets/order_bottomsheet.dart';

class SkeletonizerOrder extends StatelessWidget {
  const SkeletonizerOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black87
                            )
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20,),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("ggggggggg"),
                                  Text("GGGGGGGGGGG")
                                ],
                              ),
                              BuyerOrderWidget(productInformation: ProductInformation.Empty(), onCount: (int ) {},stop: true,),
                              OrderBottomsheet(information: OrderInformation.Empty(),)
                            ],
                          ),
                        ),
                      );
  }
}