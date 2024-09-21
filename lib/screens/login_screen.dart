

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/services/account_controller.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _isObscure3 = true;
  //bool visible = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
 

  bool _isLoading = false;

   AccountController accountController= Get.find(tag: "account");

  @override
  void initState() {
    super.initState();
  }


  _loginUsers() async {

    if (_formkey.currentState!.validate()) {
     await accountController.Signin(emailController.text, passwordController.text);
    } else {
      Get.showSnackbar(const GetSnackBar(message: "please enter a valid email and password"));
    }
    
    setState(() {
        _isLoading = false;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:MediaQuery.of(context).size.height*0.25),
              const Text(
                "Welcome back !",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 36,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Enter ur email and password to continue",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500],
                  ),
                ),
              ),
               const SizedBox(
                height: 10,
              ),
              Container(
                margin:const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    prefixIconColor: Colors.black54,
            
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 12.0, top: 12.0),
                    border:  OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder:  OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
                ),
              ),
              Container(
                margin:const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure3,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: Colors.black54,
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure3
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure3 = !_isObscure3;
                          });
                        }),
                    filled: true,
                    hintText: 'Password',
                    enabled: true,
                    fillColor: Colors.white,
                    border:  OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder:  OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 12.0, top: 12.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide:const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'password must not be empty ';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
             const SizedBox(
                height: 5,
              ),
              //forget mot de passe
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot password ?',
                      style: TextStyle(
                          color: Color.fromRGBO(36, 36, 36, 0.5)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: () async{
                  
                  setState(() {
                    _isLoading = true;
                  });
                  _formkey.currentState?.save();
                  _loginUsers();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 46,
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
                      "Login",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "you don't have an account ?",
                    style: TextStyle(color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Get.toNamed("/signup_screen");
                      Get.toNamed("/signup_screen");
            
                    },
                    child: const Text(
                      ' Sign Up ',
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
    );
  }
}