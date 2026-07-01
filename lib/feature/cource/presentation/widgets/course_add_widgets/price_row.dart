
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_text_field.dart';
import 'package:flutter/material.dart';

class PricingRow extends StatelessWidget {
  const PricingRow({super.key, 
    required this.priceController,
    required this.offerPriceController,
    required this.taxController,
  });

  final TextEditingController priceController;
  final TextEditingController offerPriceController;
  final TextEditingController taxController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DialogTextField(
            controller: priceController,
            hint: 'Price',
            isItalic: true,
            isNumber: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DialogTextField(
            controller: offerPriceController,
            hint: 'Offer Price',
            isItalic: true,
            isNumber: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DialogTextField(
            controller: taxController,
            hint: 'Tax %',
            isItalic: true,
            isNumber: true,
            suffixIcon:
                const Icon(Icons.percent, color: Colors.black54, size: 18),
          ),
        ),
      ],
    );
  }
}
