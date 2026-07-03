import 'package:flutter/material.dart';

class PayementOptionScreen extends StatelessWidget {
  const PayementOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Payment Options",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: const [
                PaymentPlatformCard(
                  icon: Icons.android,
                  isOnlinePaymentOn: false,
                  isWhatsAppOn: true,
                  isCallOn: true,
                ),
                SizedBox(height: 24),
                PaymentPlatformCard(
                  icon: Icons.apple,
                  isOnlinePaymentOn: false,
                  isWhatsAppOn: false,
                  isCallOn: false,
                ),
                SizedBox(height: 24),
                PaymentPlatformCard(
                  icon: Icons.language,
                  isOnlinePaymentOn: false,
                  isWhatsAppOn: false,
                  isCallOn: false,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentPlatformCard extends StatefulWidget {
  final IconData icon;
  final bool isOnlinePaymentOn;
  final bool isWhatsAppOn;
  final bool isCallOn;

  const PaymentPlatformCard({
    super.key,
    required this.icon,
    required this.isOnlinePaymentOn,
    required this.isWhatsAppOn,
    required this.isCallOn,
  });

  @override
  State<PaymentPlatformCard> createState() => _PaymentPlatformCardState();
}

class _PaymentPlatformCardState extends State<PaymentPlatformCard> {
  late bool onlinePayment;
  late bool whatsapp;
  late bool call;

  @override
  void initState() {
    super.initState();
    onlinePayment = widget.isOnlinePaymentOn;
    whatsapp = widget.isWhatsAppOn;
    call = widget.isCallOn;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 40),

              // Toggles
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildToggleContainer('Online Payment', onlinePayment, (
                      val,
                    ) {
                      setState(() => onlinePayment = val);
                    }),
                    _buildToggleContainer('Connect WhatsApp', whatsapp, (val) {
                      setState(() => whatsapp = val);
                    }),
                    _buildToggleContainer('Connect Call', call, (val) {
                      setState(() => call = val);
                    }),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Button Rename Field
          const Text(
            'Button Rename',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 300,
            height: 44,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Button Content',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                filled: true,
                fillColor: const Color(0xFFEEEEEE),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Save Button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleContainer(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Expanded(
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12, // slightly smaller to fit better
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ),
            Transform.scale(
              scale: 0.70, // slightly smaller switch
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.green,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
