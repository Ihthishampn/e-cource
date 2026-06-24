import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isPass;
  final IconData icons;
  final FormFieldValidator<String> validator;
  const CustomTextField({
    super.key,
    required this.hint,
    required this.icons,
    this.isPass = false,
    required this.validator, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: isPass ? TextInputType.text : TextInputType.emailAddress,
        obscureText: isPass ? true : false,
        decoration: InputDecoration(
          suffixIcon: isPass ? Icon(Icons.visibility_off_outlined) : null,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 15),
          prefixIcon: Icon(icons),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 15, 71, 117),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: const Color.fromARGB(255, 16, 80, 133),
            ),
          ),
        ),
      ),
    );
  }
}
