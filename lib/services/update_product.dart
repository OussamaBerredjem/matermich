import 'package:get/get.dart';
import 'package:matermich/models/product_information.dart';

class UpdateProduct extends GetxController{
  ProductInformation productInformation;

  UpdateProduct({required this.productInformation});

  void SetUpdate(ProductInformation product){
    productInformation = product;
    update();
  }
}