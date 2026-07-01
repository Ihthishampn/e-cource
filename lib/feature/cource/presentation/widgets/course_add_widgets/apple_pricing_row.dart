import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_text_field.dart';
import 'package:flutter/material.dart';

class ApplePricingRow extends StatelessWidget {
  const ApplePricingRow({super.key, 
    required this.applePriceController,
    required this.appleOfferPriceController,
  });

  final TextEditingController applePriceController;
  final TextEditingController appleOfferPriceController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DialogTextField(
            controller: applePriceController,
            hint: 'Apple Price',
            isItalic: true,
            isNumber: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DialogTextField(
            controller: appleOfferPriceController,
            hint: 'Apple Offer Price',
            isItalic: true,
            isNumber: true,
          ),
        ),
      ],
    );
  }
}
