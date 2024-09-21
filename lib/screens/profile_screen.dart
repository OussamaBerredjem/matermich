import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:matermich/screens/login_screen.dart';
import 'package:matermich/screens/personal_screen.dart';
import 'package:matermich/screens/chat_screen.dart';
import 'package:matermich/screens/location_screen.dart';
import 'package:matermich/screens/wishlist_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
    
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Account",style: GoogleFonts.roboto(color: Colors.black),),
        ),
        ListTile(
          onTap: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>const PersonalScreen()));
          },
          leading: Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.green
            ),
            child: const Icon(Icons.person,color: Colors.white,size: 16,)),
          title: Text("Personal Information",style: GoogleFonts.roboto(color: Colors.black),),
          subtitle: const Text("my profile information"),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),

        ),
         ListTile(
          onTap: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>LocationScreen(change: true,)));

          },
          leading: Container(
             height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.amber
            ),
            child: const Icon(Icons.location_on,color: Colors.white,size: 16,)),
          title: Text("Delivery Adress",style: GoogleFonts.roboto(color: Colors.black),),
          subtitle: const Text("my delivery address"),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Common",style: GoogleFonts.roboto(color: Colors.black),),
        ),
         ListTile(
          onTap: (){
            Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>const ChatScreen()));

          },
          leading: Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurpleAccent
            ),
            child: const Icon(Ionicons.chatbubbles,color: Colors.white,size: 16,)),
          title: Text("Messages",style: GoogleFonts.roboto(color: Colors.black),),
          subtitle: const Text("my messages list"),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),

        ),

         ListTile(
          onTap: (){
                 Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>const WishlistScreen()));

          },
          leading: Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.pinkAccent
            ),
            child: const Icon(Icons.favorite,color: Colors.white,size: 16,)),
          title: Text("Wishlist",style: GoogleFonts.roboto(color: Colors.black),),
          subtitle: const Text("my favorite items"),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Services",style: GoogleFonts.roboto(color: Colors.black),),
        ),
         ListTile(
          leading: Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:Colors.blue
            ),
            child: const Icon(Ionicons.headset,color: Colors.white,size: 16,)),
          title: Text("Help & Support",style: GoogleFonts.roboto(color: Colors.black),),
          subtitle: const Text("Talk us"),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),

        ),
         ListTile(
          leading: Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black38
            ),
            child: const Icon(Ionicons.alert_circle_outline,color: Colors.white,size: 16,)),
          title: Text("About",style: GoogleFonts.roboto(color: Colors.black),),
          subtitle: const Text("Learn more"),
          trailing: const Icon(Icons.keyboard_arrow_right_outlined),

        ),
        const SizedBox(height: 15,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: (MediaQuery.of(context).size.width*0.03)),
          child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                        maximumSize: Size((MediaQuery.of(context).size.width*0.7), 48),
                        minimumSize: Size((MediaQuery.of(context).size.width*0.7), (48)),
                        
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.redAccent.withOpacity(.8)
                          ),
                          borderRadius: BorderRadius.circular(12), // Change this value for a different radius
                        ),
                      ),
                  onPressed: () async{
                    await FirebaseAuth.instance.signOut();
                    Get.offAll(()=>const LoginScreen());
                  }, 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width*0.3,
                        child: Text("    Logout",style: TextStyle(color: Colors.black.withOpacity(.6).withOpacity(.81),fontWeight: FontWeight.w500,fontSize: 18),)),
                      Icon(Icons.logout,color: Colors.black.withOpacity(.6),size: 20,)
                    ],
                  )),
        ),
                
      ],
    );
  }
}