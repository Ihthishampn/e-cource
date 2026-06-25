import 'package:flutter/material.dart';

class CustomSearch extends StatelessWidget {
  const CustomSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 490,
      child: SearchBar(
        leading: const Icon(Icons.search, color: Colors.black54),
        hintText: "Search user by name & phone number",
        hintStyle: WidgetStatePropertyAll(
          TextStyle(
            color: const Color.fromARGB(255, 138, 138, 138),
            fontSize: 14,
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(Colors.grey.shade200),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
