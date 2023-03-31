import 'package:flutter/material.dart';

InputDecoration registerInputDecoration(
    {required String hintText, required IconData icon, Color? color}) {
  return InputDecoration(
    counterStyle: TextStyle(color: color ?? Colors.white),
    contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    hintStyle: TextStyle(color: color ?? Colors.white, fontSize: 18),
    hintText: hintText,
    prefixIcon: Icon(
      icon,
      color: Colors.white,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color ?? Colors.white, width: 2),
      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color ?? Colors.white),
      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffFFA62B)),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Color(0xffFFA62B)),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    errorStyle: const TextStyle(color: Colors.amber),
  );
}

InputDecoration signInInputDecoration(
    {required String hintText, required IconData icon}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    hintStyle: const TextStyle(fontSize: 18),
    hintText: hintText,
    prefixIcon: Icon(
      icon,
      color: const Color(0xff092E34),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Color(0xff092E34)),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xff092E34)),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffCC7700)),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Color(0xffCC7700)),
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    errorStyle: const TextStyle(color: Color(0xffCC7700)),
  );
}
