import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matermich/services/account_controller.dart';
import 'package:matermich/services/location_pick_controller.dart';

class LocationScreen extends StatefulWidget {
  bool change;
  LocationScreen({super.key,this.change = false});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  TextEditingController location = TextEditingController(text:"Pick a Location");
  final LocationPickController _locationPickController = Get.put(LocationPickController(),tag: "location");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(automaticallyImplyLeading: true,forceMaterialTransparency: true,),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 150,
                child: Image.asset("assets/icons/icon_location.png")
              ),
              const SizedBox(height: 10,),
              const Text("Confirme Location",style:TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 25,letterSpacing: 1.5,shadows: [
                Shadow(
                  offset: Offset(-.5, -.5), // تحريك الظل
                  color: Colors.grey,
                ),
                Shadow(
                  offset: Offset(.5, -.5),
                  color: Colors.grey,
                ),
                Shadow(
                  offset: Offset(.5, .5),
                  color: Colors.grey,
                ),
                Shadow(
                  offset: Offset(-.5, .5),
                  color: Colors.grey,
                ),
              ],)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                child: Text("Matermich requires access to your location to ensure accurate and efficient delivery services. By enabling location access, our delivery personnel can pinpoint your exact address",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54),),
              ),
              GetBuilder<LocationPickController>(
                tag: "location",
                builder: (lcontroller) {
                  if(_locationPickController.location.value.isEmpty){
                location.text = Get.find<AccountController>(tag:"account").information.value.location;

                  }else{
                location.text = _locationPickController.location.value;

                  }
  return Padding(
    padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
    child: TextField(
      onTap: () {
        Get.toNamed("location_picker");
      },
      readOnly: true,
      controller: location,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.edit),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green),
        ),
      ),
    ),
  );
})
 ],
          ),
          ),
      ),
      
      bottomNavigationBar:  
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              
                ElevatedButton(
                
                style: ElevatedButton.styleFrom(
                      maximumSize: Size((MediaQuery.of(context).size.width*0.9), 53),
                      minimumSize: Size((MediaQuery.of(context).size.width*0.9), (53)),
                      backgroundColor: Colors.green.withOpacity(.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Change this value for a different radius
                      ),
                    ),
                onPressed: () async{
                  if(_locationPickController.location.isEmpty){
                    Get.showSnackbar(const GetSnackBar(title: "Pick a Location first",));
                  }else{
                    setState(() {
                    _isLoading = true;
                  });
                  
                  await _locationPickController.updateLocation(change: widget.change);

                   setState(() {
                    _isLoading = false;
                  });
                  }
                }, 
                child: _isLoading? const SizedBox(
                                  height: 15,
                                  width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ):Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(!widget.change?"    Continue":"    Save",style: TextStyle(color: Colors.white.withOpacity(.81),fontWeight: FontWeight.w900,fontSize: 19),)),
                    Visibility(visible: !widget.change,child:const Icon(Icons.arrow_right_alt,color: Colors.white70,size: 38,))
                  ],
                )),
                const SizedBox(height: 60,)
              ],
            ),
          
        
     
    );
  }
}