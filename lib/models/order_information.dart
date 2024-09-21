// ignore_for_file: non_constant_identifier_names


import 'package:get/get.dart';
import 'package:matermich/models/order_status.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/models/user_information.dart';
import 'package:matermich/services/account_controller.dart';

class OrderInformation{
  List<ProductInformation> products;
  UserInformation userInformation;
  String status,id = "";
  int subtotal = 0,total = 0,tax = 0;
  final AccountController _accountController = Get.find(tag:"account");


  OrderInformation({
    required this.products,
    required this.userInformation,
    required this.status
  });

  void totals(){
    subtotal =0;
    total = 0;
    tax = 0;
    for (var value in products) {
      subtotal += int.parse(value.price) * value.quantite;
      tax += int.parse(value.tax) * value.quantite;
      total = subtotal + tax;
    }

  }

  Map<String, dynamic> toCheckoutMap() {
    return {
      'sellerUid':userInformation.uid,
      'buyerUid':_accountController.information.value.uid,
      'seller': userInformation.toMap(),
      'buyer':_accountController.information.value.toMap(),
      'status': status,
      'id': id,
      'subtotal': subtotal,
      'total': total,
      'tax': tax,
    };
  }

  OrderInformation.Empty():products = [ProductInformation.Empty()],userInformation = UserInformation.Empty(),status=OrderStatus.cart;
  OrderInformation.fromFirestore(Map<String,dynamic> map):
    userInformation=UserInformation.fromOrder(map["buyerUid"],map['buyer']),
    status=map['status'],
    id=map['id'],
    subtotal=map['subtotal'],
    total= map['total'],
    tax=map['tax'],
    products=[];
}