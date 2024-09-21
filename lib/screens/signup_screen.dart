import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matermich/models/user_information.dart';
import 'package:matermich/services/account_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _path = "";
  bool _isLoading = false,seller = false;

  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      numberController = TextEditingController(),
      fullnameController = TextEditingController();
  

  _SignupUsers() async {
    if (_formkey.currentState!.validate() && _path.isNotEmpty) {
      AccountController accountController = Get.find(tag: "account");
      await accountController.Signup(UserInformation.withoutLocation(fullname: fullnameController.text, email: emailController.text, image: _path, number: numberController.text, role: seller, password: passwordController.text,uid: ""));
    } else {
      Get.showSnackbar(const GetSnackBar(title:"error",message: "please enter a valid information"));
    }

    setState(() {
      _isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "Signup",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 36,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text("create your new acccount et joindre nous"),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: 100,
                    height: 100,
                    child: GestureDetector(
                      onTap: () async {},
                      child: Stack(
                        children: [
                          GestureDetector(
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
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 249, 249, 249),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: _path.isNotEmpty
                                    ? Image.file(
                                        File(_path),
                                        fit: BoxFit.cover,
                                        width: 100.0,
                                        height: 100.0,
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          color: Colors.grey,
                                          Icons.person,
                                          size: 80,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 20, left: 20),
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Icon(
                                  Icons.edit_sharp,
                                  color: Colors.white,
                                  size: 19,
                                )),
                          )
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TextFormField(
                    controller: fullnameController,
                    validator: (value) {
                      if (value == null || value.length < 10) {
                        return 'Fullname must be at least 8 characters long';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'Fullname',
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
                TextFormField(
                  controller: numberController,
                  validator: (value) {
                      if (value == null || value.length < 9) {
                        return 'Number must be at least 10 characters long';
                      }
                      return null;
                    },
                  decoration: InputDecoration(
                    hintText: 'Number',
                    prefixIcon: const Icon(Icons.call),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                              if (value!.isEmpty) {
                                return "Email cannot be empty";
                              }
                              if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                  .hasMatch(value)) {
                                return ("Please enter a valid email");
                              } else {
                                return null;
                              }
                            },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'Email',
                    
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                      if (value == null || value.length < 7) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    const Text('Buyer'),
    Radio(
      activeColor: Colors.green,
      value: false,
      groupValue: seller,
      onChanged: (value) => setState(() {seller = value??true;print("seller : $seller");}),
    ),
    const SizedBox(width: 20,),
    const Text('Seller'),
    Radio(
      activeColor: Colors.green,
      value: true,
      groupValue: seller,
      onChanged: (value) => setState((){seller = value??false;print("seller : $seller");}),
    ),
  ],
),
                const SizedBox(
                  height: 10
                  ,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _SignupUsers();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 53,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                                  height: 15,
                                  width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Signup",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous avez un compte ?',
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        ' Login ',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
