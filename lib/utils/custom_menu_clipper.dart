import 'package:flutter/material.dart';

class CustomMenuClipper extends CustomClipper<Path> {

  String position;

  CustomMenuClipper({required this.position});

  @override
  Path getClip(Size size) {

    Paint paint=Paint();
    paint.color=Colors.red;

    final width=size.width;
    final height=size.height;

    if(position=="left"){
      Path path=Path();
      path.moveTo(width, 0);
      path.quadraticBezierTo(width, 8, width-10, 16);
      path.quadraticBezierTo(1, height/2-20, 0, height/2);
      path.quadraticBezierTo(-1, height/2+20, width-10, height-16);
      path.quadraticBezierTo(width, height-8, width, height);


      /* path.moveTo(0, 0);
     path.quadraticBezierTo(0, 8, 10, 16);
     path.quadraticBezierTo(width-1, height/2-20, width, height/2);
     path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
     path.quadraticBezierTo(0, height-8, 0, height);*/
      path.close();
      return path;
    }else{
      Path path=Path();
      path.moveTo(0, 0);
      path.quadraticBezierTo(0, 8, 10, 16);
      path.quadraticBezierTo(width-1, height/2-20, width, height/2);
      path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
      path.quadraticBezierTo(0, height-8, 0, height);
      path.close();
      return path;
    }
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}