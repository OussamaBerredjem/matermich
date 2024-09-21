import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/product_information.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/seller_product_controller.dart';

import '../models/product_categorie.dart';

class AddProductScreen extends StatefulWidget {
  ProductInformation? product;
  bool edit;
  AddProductScreen({super.key,this.product,this.edit = false});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String _path = "";
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final SellerProductController _sellerProductController = Get.find(tag:"product");
  final AccountController _accountController = Get.find(tag:"account");

  TextEditingController name = TextEditingController(),
      desc = TextEditingController(),
      price = TextEditingController(),
      expiration = TextEditingController(),
      categorie = TextEditingController(),
      donation = TextEditingController(),
      tax = TextEditingController();

  ValueNotifier<bool> isdonate = ValueNotifier(false);

  @override
  void initState() {
    // TODO: implement initState
    if(widget.edit){
      desc.text = widget.product?.desc??"";
      price.text = widget.product?.price??"";
      expiration.text = widget.product?.expiration??"";
      donation.text = widget.product?.desc??"";
      tax.text = widget.product?.tax??"";
      name.text = widget.product?.name??"";
      categorie.text = widget.product?.categorie??"";

      if(price.text == "0"){
        isdonate.value = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.edit?"Edit Product":"Add Product",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context,value,child) {
            return IgnorePointer(
              ignoring: _isLoading.value,
              child: Form(
                key: _formkey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 120,
                          height: 120,
                          child: GestureDetector(
                            onTap: () async {
                              // ignore: invalid_use_of_visible_for_testing_member
                              XFile? xfile = await ImagePicker.platform
                                  .getImageFromSource(
                                      source: ImageSource.gallery);
                              if (xfile != null) {
                                setState(() {
                                  _path = xfile.path;
                                });
                              }
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black38
                                  ),
                                  color: const Color.fromARGB(255, 249, 249, 249),
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(image:_path.isEmpty && widget.edit? NetworkImage("${widget.product?.photo}"):FileImage(File(_path)),fit: BoxFit.cover)
                                  ),
                              child:  Visibility(
                                visible:_path.isEmpty && !widget.edit,
                                child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          color: Colors.grey,
                                          Icons.add_a_photo_outlined,
                                          
                                        ),
                                      ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                     const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: name,
                                validator: (value) {
                                  if (value == null ||
                                      value.length < 4 ||
                                      value.length > 15) {
                                    return 'Name must be between  5-15 characters';
                                  }
                                  return null;
                                },
                               
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Ionicons.fast_food_outline),
                                  hintText: 'Product name',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                maxLines: 3,
                                minLines: 1,
                                controller: desc,
                                validator: (value) {
                                  if (value == null ||
                                      value.length < 9 ||
                                      value.length > 50) {
                                    return 'Description must be between 10-50 characters';
                                  }
                                  return null;
                                },
                              
                                decoration: InputDecoration(
                                  hintText: 'Description',
                                  prefixIcon: const Icon(Icons.list_alt_outlined),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                onTap: () async {
                                  showModalBottomSheet(
                                      context: context,
                                      enableDrag: true,
                                      isDismissible: true,
                                      isScrollControlled: true,
                                      sheetAnimationStyle:
                                          AnimationStyle(curve: Curves.fastOutSlowIn),
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(vertical: 12),
                                              width: 120,
                                              height: 3,
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: BorderRadius.circular(12)),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                categorie.text = ProductCategorie.sandwich;
                                                Get.back();
                                              },
                                              leading: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/sandwich_icon.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              trailing: const Icon(Icons.keyboard_arrow_right),
                                              title: const Text(
                                                "Sandwich",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                categorie.text = ProductCategorie.cake;
                                                Get.back();
                                              },
                                              leading: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/cake_icon.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              trailing: const Icon(Icons.keyboard_arrow_right),
                                              title: const Text(
                                                "Cakes",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                categorie.text = ProductCategorie.bread;
                                                Get.back();
                                              },
                                              leading: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/breads_icon.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              trailing: const Icon(Icons.keyboard_arrow_right),
                                              title: const Text(
                                                "Breads",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                categorie.text = ProductCategorie.juice;
                                                Get.back();
                                              },
                                              leading: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/juice_icon.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              trailing: const Icon(Icons.keyboard_arrow_right),
                                              title: const Text(
                                                "Juices",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ListTile(
                                              onTap: () {
                                                categorie.text = ProductCategorie.milk;
                                                Get.back();
                                              },
                                              leading: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/icons/milk_icon.png"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                              trailing: const Icon(Icons.keyboard_arrow_right),
                                              title: const Text(
                                                "Milks",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 35,
                                            ),
                                          ],
                                        );
                                      });
                                },
                                readOnly: true,
                                controller: categorie,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'you must enter categorie';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Categorie',
                                  prefixIcon: const Icon(Icons.dashboard_outlined),
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: expiration,
                                readOnly: true,
                                onTap: () async {
                                  DateTime d = DateTime.now().add(const Duration(days: 2190));
                                  DateTime? o;
                      
                                  o = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2024),
                                      lastDate: d);
                      
                                  expiration.text =
                                      "${o?.day ?? ''}/${o?.month ?? ''}/${o?.year ?? ''}";
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'you must enter expiration date';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Expiration Date',
                                  prefixIcon: const Icon(Ionicons.calendar_outline),
                                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ValueListenableBuilder(
                              valueListenable: isdonate,
                              builder: (context,l,child) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  child: TextFormField(
                                    readOnly: l,
                                    controller: price,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'you must enter price';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Price',
                                      prefixIcon: const Icon(Ionicons.cash_outline),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: ValueListenableBuilder(
                                valueListenable: isdonate,
                                builder: (context,l,child) {
                                  return TextFormField(
                                    controller: tax,
                                    readOnly: l,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'you must enter tax';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Ionicons.cash),
                                      hintText: 'Tax',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                             const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: donation,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Ionicons.bag_outline),
                                  suffixIcon: ValueListenableBuilder(
                                    valueListenable: isdonate,
                                    builder: (context,l,child) {
                                      return Switch(
                                        activeColor: Colors.green,
                                        value: l,
                                        onChanged: (value){
                                        isdonate.value = value;
                                        price.text = "0";
                                        tax.text = "0";
                                      });
                                    }
                                  ),
                                  hintText: 'Donation',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 13,
                            ),
                           
                            
                              ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      maximumSize:
                                          Size((MediaQuery.of(context).size.width * 0.9), 53),
                                      minimumSize:
                                          Size((MediaQuery.of(context).size.width * 0.9), (53)),
                                      backgroundColor: Colors.green.withOpacity(.8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12), // Change this value for a different radius
                                      ),
                                    ),
                                    onPressed: () async {
                                      if(_formkey.currentState!.validate() && (_path.isNotEmpty || widget.edit)){
                                       _isLoading.value = true;
                                      FocusScope.of(context).unfocus();
                                      if(widget.edit){
                                        ProductInformation p = ProductInformation(name: name.text, desc: desc.text, seller: _accountController.information.value, categorie: categorie.text, price: price.text, uid: widget.product!.uid, tax: tax.text, photo: "",expiration: expiration.text);
                                        p.photo = _path.isEmpty ? widget.product!.photo:_path;
                                      await _sellerProductController.addProduct(p,changedImage: _path.isNotEmpty,edit: true);

                                      }else{
                                      await _sellerProductController.addProduct(ProductInformation(name: name.text, desc: desc.text, seller: _accountController.information.value, categorie: categorie.text, price: price.text, uid: "", tax: tax.text, photo: _path,expiration: expiration.text));

                                      }
                                      _isLoading.value = false;
                                      Navigator.of(context).pop();
                                      }else{
                                        Get.snackbar("Missing feilds", "please fill all feilds",backgroundColor: Colors.red.shade100);
                                      }
                                   
                                    },
                                    child: value
                                        ? const SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    widget.edit?"    Edit":"    Add",
                                                    style: TextStyle(
                                                        color: Colors.white.withOpacity(.81),
                                                        fontWeight: FontWeight.w900,
                                                        fontSize: 19),
                                                  )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                widget.edit?Ionicons.create_outline:Icons.add,
                                                color: Colors.white70,
                                              )
                                            ],
                                          )),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
