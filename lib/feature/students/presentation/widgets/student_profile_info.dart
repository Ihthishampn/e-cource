import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StudentProfileInfo extends StatefulWidget {
  final Map<String, String> studentData;

  const StudentProfileInfo({super.key, required this.studentData});

  @override
  State<StudentProfileInfo> createState() => _StudentProfileInfoState();
}

class _StudentProfileInfoState extends State<StudentProfileInfo> {
  late bool _isEnabled;
  late bool _hasWebAccess;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.studentData['status']?.toLowerCase() == 'enable';
    _hasWebAccess = false; // default value
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.studentData['name'] ?? '';
    final phone = widget.studentData['phone'] ?? '';
    final email = widget.studentData['email'] ?? '';
    final joinedAt = widget.studentData['joinedAt'] ?? '';
    final status = widget.studentData['status'] ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar + Switches Column
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSwitchColumn(
                  label: "Enable",
                  value: _isEnabled,
                  activeColor: Colors.green,
                  onChanged: (val) {
                    setState(() {
                      _isEnabled = val;
                    });
                  },
                ),
                const Gap(12),
                _buildSwitchColumn(
                  label: "Web Access",
                  value: _hasWebAccess,
                  activeColor: Colors.red,
                  onChanged: (val) {
                    setState(() {
                      _hasWebAccess = val;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const Gap(40),

        // Details Column
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Name", name),
                const Gap(8),
                _buildDetailRow("Number", phone),
                const Gap(8),
                _buildDetailRow("Email", email),
                const Gap(8),
                _buildDetailRow("Joined At", joinedAt),
                const Gap(8),
                _buildDetailRow(
                  "Status",
                  status,
                  valueColor: status.toLowerCase() == 'enable'
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchColumn({
    required String label,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const Gap(4),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: activeColor,
            inactiveTrackColor: Colors.grey.shade300,
            inactiveThumbColor: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ),
        const Text(
          ":  ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
