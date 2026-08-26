import 'package:flutter/material.dart';

class ResponsiveHelper extends StatelessWidget {
  final Widget landscape;
  final Widget portrait;

  const ResponsiveHelper({super.key, required this.landscape,  required this.portrait});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(MediaQuery.of(context).orientation==Orientation.portrait){
        return portrait;
      }else{
        return landscape;
      }
    });
  }
}
