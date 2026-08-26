import 'package:flutter/material.dart';
import '../../constraints/header_text.dart';

class CustomDivider extends StatelessWidget {
 final String text;
   const CustomDivider({Key? key, this.text="OR LOGIN WITH"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: HeaderText(text: text, align: TextAlign.center,fontWeight: FontWeight.normal,size: 18,),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
