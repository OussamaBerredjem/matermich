import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/models/ads_model.dart';
import 'package:matermich/models/product_categorie.dart';

import '../services/account_controller.dart';
import '../services/seller_product_controller.dart';

class AddAdsScreen extends StatefulWidget {
  const AddAdsScreen({super.key});

  @override
  State<AddAdsScreen> createState() => _AddAdsScreenState();
}

class _AddAdsScreenState extends State<AddAdsScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final SellerProductController _sellerProductController = Get.find(tag: "product");
  final AccountController _accountController = Get.find(tag: "account");

  TextEditingController name = TextEditingController(),
      desc = TextEditingController(),
      price = TextEditingController(),
      categorie = TextEditingController(),
      expiration = TextEditingController(),
      tax = TextEditingController();
  
  final ValueNotifier<bool> _isLodaing = ValueNotifier(false);

  String _path = "", _name = "", _desc = "", _price = "";
  String _p_path = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Promotion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: _isLodaing,
          builder: (context,val,child) {
            return IgnorePointer(
              ignoring: _isLodaing.value,
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          Positioned(
                              top: 5,
                              bottom: 5,
                              left: 9,
                              right: 9,
                              child: GestureDetector(
                                onTap: () async {
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
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      image: _path.isNotEmpty
                                          ? DecorationImage(
                                              image: FileImage(File(_path)),
                                              fit: BoxFit.cover)
                                          : null,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black,
                                      )),
                                  child: Visibility(
                                    visible: _path.isEmpty,
                                    child: const Center(
                                      child: Icon(Icons.add_a_photo_outlined),
                                    ),
                                  ),
                                ),
                              )),
                          Positioned(
                            top: 8,
                            right: 20,
                            left: 20,
                            bottom: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      child: Text(
                                        _name,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              // Top-left shadow
                                              offset: const Offset(-2.0, -2.0),
                                              blurRadius: 3.0,
                                              color: Colors.grey.withOpacity(0.5),
                                            ),
                                            Shadow(
                                              // Top-right shadow
                                              offset: const Offset(2.0, -2.0),
                                              blurRadius: 3.0,
                                              color: Colors.grey.withOpacity(0.5),
                                            ),
                                            Shadow(
                                              // Bottom-right shadow
                                              offset: const Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Colors.grey.withOpacity(0.5),
                                            ),
                                            Shadow(
                                              // Bottom-left shadow
                                              offset: const Offset(-2.0, 2.0),
                                              blurRadius: 3.0,
                                              color: Colors.grey.withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          _desc,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            shadows: [
                                              Shadow(
                                                // Top-left shadow
                                                offset: const Offset(-2.0, -2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                              Shadow(
                                                // Top-right shadow
                                                offset: const Offset(2.0, -2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                              Shadow(
                                                // Bottom-right shadow
                                                offset: const Offset(2.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                              Shadow(
                                                // Bottom-left shadow
                                                offset: const Offset(-2.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                        ))
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    XFile? xfile = await ImagePicker.platform
                                        .getImageFromSource(
                                            source: ImageSource.gallery);
                                    if (xfile != null) {
                                      setState(() {
                                        _p_path = xfile.path;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        image: _p_path.isNotEmpty
                                            ? DecorationImage(
                                                image: FileImage(File(_p_path)),
                                                fit: BoxFit.cover)
                                            : null,
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.black)),
                                    child: Visibility(
                                      visible: _p_path.isEmpty,
                                      child: const Center(
                                        child: Icon(Icons.add_a_photo_outlined),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 30,
                            child: Text(
                                          "$_price DZD",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            shadows: [
                                              Shadow(
                                                // Top-left shadow
                                                offset: const Offset(-2.0, -2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                              Shadow(
                                                // Top-right shadow
                                                offset: const Offset(2.0, -2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                              Shadow(
                                                // Bottom-right shadow
                                                offset: const Offset(2.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                              Shadow(
                                                // Bottom-left shadow
                                                offset: const Offset(-2.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Colors.grey.withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                        ) )
                        ],
                      ),
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
                        onChanged: (value){
                          setState(() {
                            _name = value;
                          });
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
                        onChanged: (value){
                          setState(() {
                            _desc = value;
                          });
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        onChanged: (value){
                          setState(() {
                            _price = value;
                          });
                        },
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
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        controller: tax,
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
                              if(_formkey.currentState!.validate() && _path.isNotEmpty && _p_path.isNotEmpty){
                               _isLodaing.value = true;
                              FocusScope.of(context).unfocus();
                              await _sellerProductController.addAds(AdsModel(name: name.text, desc: desc.text, seller: _accountController.information.value, categorie: categorie.text, price: price.text, uid: "", tax: tax.text, photo: _path, cover: _p_path,expiration: expiration.text));
                              _isLodaing.value = false;
                              Navigator.of(context).pop();
                              }else{
                                        Get.snackbar("Missing feilds", "please fill all feilds",backgroundColor: Colors.red.shade100);
                                      }
                           
                            },
                            child: val
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
                                            "    Add",
                                            style: TextStyle(
                                                color: Colors.white.withOpacity(.81),
                                                fontWeight: FontWeight.w900,
                                                fontSize: 19),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        Icons.add,
                                        color: Colors.white70,
                                      )
                                    ],
                                  )),
                      
                    
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
