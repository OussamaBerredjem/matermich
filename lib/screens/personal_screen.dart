import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/services/account_controller.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  late TextEditingController _email;
  late TextEditingController _phone,_fullname = TextEditingController(text: _accountController.information.value.fullname);

  String _path  = "";
  bool edit = false,loading  = false;
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  final AccountController _accountController = Get.find(tag:"account");
  @override
  void initState() {
  
    _phone = TextEditingController(text: _accountController.information.value.number);
    _email = TextEditingController(text: _accountController.information.value.email);

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Personal Information",style: GoogleFonts.rubik(fontWeight: FontWeight.bold,color: Colors.black),),
      ),
      body: Form(
        key: _formkey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async{
                      if(edit){
                        XFile? xfile = await ImagePicker.platform
                                    .getImageFromSource(
                                        source: ImageSource.gallery);
                                if (xfile != null) {
                                  setState(() {
                                    _path = xfile.path;
                                  });
                                }
                        }
                    },
                    child: Container(
                          height: 70,
                          width: 70,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image:  DecorationImage(image:_path.isNotEmpty && edit? FileImage(File(_path)):NetworkImage(_accountController.information.value.image),fit: BoxFit.cover)
                          ),
                        ),
                  ),
                ),
                 Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: TextFormField(
                    readOnly: !edit,
                    controller: _fullname,
                    validator: (value) {
                                if (value!.isEmpty) {
                                  return "Fullname cannot be empty";
                                }
                                if (value.length < 8){
                                  return ("Fullname must be more than 8 character");
                                }
                                  return null;
                                
                              },
                    style: GoogleFonts.roboto(fontWeight: FontWeight.w500,fontSize: 21),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none
                    ),
                  )
                  ),
         
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(top: 15),
        
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width *0.9,
              
              child: TextFormField(
                controller: _email,
                readOnly: !edit,
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
                prefixIcon: const Icon(Icons.email,color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13)
                )
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 7),
            child: SizedBox(
              width: MediaQuery.of(context).size.width *0.9,
              
              child: TextFormField(
                validator: (value){
                  if(value?.isEmpty??true){
                    return "number must be not empty";
                  }else if(value!.length <10){
                    return "number must be 10 character";
                  }
                  return null;
                },
                controller: _phone,
                readOnly: !edit,
                decoration: InputDecoration(
                
                prefixIcon: const Icon(Icons.call,color: Colors.green),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13)
                )
                ),
              ),
            ),
          ),
           
            SizedBox.fromSize(size: const Size.fromHeight(20),),
           Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
             child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                          maximumSize: Size((MediaQuery.of(context).size.width*0.9), 50),
                          minimumSize: Size((MediaQuery.of(context).size.width*0.9), (50)),
                          backgroundColor: Colors.green.withOpacity(.8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Change this value for a different radius
                          ),
                        ),
                    onPressed: () async{
                      if(edit == false){
                         setState(() {
                          edit = true;
                        });
                      }else if(_formkey.currentState!.validate()){
                        setState(() {
                          edit = false;
                          loading = true;
                        });
                        await _accountController.updateProfile(path: _path, number: _phone.text, email: _email.text, fullname: _fullname.text);
                        setState(() {
                          loading = false;
                          _path = "";

                        });
                      }

                      _email.text = _accountController.information.value.email;
                     
                    }, 
                    child: loading? const SizedBox(
                                    height: 15,
                                    width: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            :Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width*0.25,
                          child: Text(edit?"Save":"Edit",style: TextStyle(color: Colors.white70.withOpacity(.81),fontWeight: FontWeight.w500,fontSize: 19),)),
                        Icon(edit?Icons.check:Ionicons.create_outline,color: Colors.white70,)
                      ],
                    )),
                    
           ),
                 
           Visibility(
            visible: edit && !loading,
             child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 15),
               child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                            maximumSize: Size((MediaQuery.of(context).size.width*0.9), 50),
                            minimumSize: Size((MediaQuery.of(context).size.width*0.9), (50)),
                            
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: Colors.redAccent.withOpacity(.8)
                              ),
                              borderRadius: BorderRadius.circular(12), // Change this value for a different radius
                            ),
                          ),
                      onPressed: () {
                        _fullname.text = _accountController.information.value.fullname;
                        _email.text = _accountController.information.value.email;
                        _phone.text =  _accountController.information.value.number;


                        setState(() {
                          edit = false;
                          });
                      }, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width*0.3,
                            child: Text("    Cancell",style: TextStyle(color: Colors.black.withOpacity(.6).withOpacity(.81),fontWeight: FontWeight.w500,fontSize: 18),)),
                          Icon(Icons.close,color: Colors.black.withOpacity(.6),size: 20,)
                        ],
                      )),
             ),
           ),
       
         ],
            ),
          ),
        ),
      ),
    );
  }
}