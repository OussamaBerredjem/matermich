import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matermich/models/order_information.dart';
import 'package:matermich/widgets/buyer_order_widget.dart';
import 'package:matermich/widgets/order_bottomsheet.dart';

// ignore: must_be_immutable
class StatusBuyerOrderWidget extends StatefulWidget {
  bool complet;
  bool seller, waitting, accept;
  OrderInformation information;
  StatusBuyerOrderWidget(
      {super.key,
      this.complet = false,
      this.seller = false,
      this.waitting = false,
      this.accept = false,
      required this.information});

  @override
  State<StatusBuyerOrderWidget> createState() => _StatusBuyerOrderWidgetState();
}

class _StatusBuyerOrderWidgetState extends State<StatusBuyerOrderWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        initiallyExpanded: true,
        collapsedShape: Border.all(width: 1),
        shape: Border.all(width: 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Order",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, fontSize: 21)),
            Text(widget.information.id.substring(0,8),
                style: GoogleFonts.poppins(fontSize: 19))
          ],
        ),
        children: [
          const Divider(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.information.products
                .map((value) => BuyerOrderWidget(
                      productInformation: value, // Use 'value' for each product
                      onCount: (count) {}, // Handle onCount if needed
                      stop: true,
                    ))
                .toList(),
          ),
          OrderBottomsheet(
            waitting: true,
            accept: widget.accept,
            complete: widget.complet,
            seller: widget.seller,
            information: widget.information,
          )
        ],
      ),
    );
  }
}
