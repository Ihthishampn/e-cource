import 'package:flutter/material.dart';

class CustomButtonLogin extends StatelessWidget {
  final VoidCallback ontap;
  final Widget widget;
  const CustomButtonLogin({super.key, required this.ontap, required this.widget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 50,
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: widget,
      ),
    );
  }
}
