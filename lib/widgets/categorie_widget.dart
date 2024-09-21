import 'package:flutter/material.dart';

class CategorieWidget extends StatelessWidget {
  String image,desc;
   CategorieWidget({super.key,required this.image,required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.15,
          width:  MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(image),fit: BoxFit.fitWidth)
          ),
        ),
        Text(desc,style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04),)
      ],
    );
  }
}