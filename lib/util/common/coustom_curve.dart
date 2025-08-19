import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class CustomCurve extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    final fastCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
      fastCurve.dx,
      fastCurve.dy,
      lastCurve.dx,
      lastCurve.dy,
    );

    final secondFastCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);

    path.quadraticBezierTo(
      secondFastCurve.dx,
      secondFastCurve.dy,
      secondLastCurve.dx,
      secondLastCurve.dy,
    );

    final thirdFastCurve = Offset(size.width , size.height - 20);
    final thirdLastCurve = Offset(size.width , size.height);

    path.quadraticBezierTo(
      thirdFastCurve.dx,
      thirdFastCurve.dy,
      thirdLastCurve.dx,
      thirdLastCurve.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
