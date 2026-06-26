import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_provider.dart';

class AddCourseDialog extends StatelessWidget {
  const AddCourseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const _AddCourseDialogContent(),
    );
  }
}

class _AddCourseDialogContent extends StatefulWidget {
  const _AddCourseDialogContent();

  @override
  State<_AddCourseDialogContent> createState() => _AddCourseDialogContentState();
}

class _AddCourseDialogContentState extends State<_AddCourseDialogContent> {
  final TextEditingController _tagController = TextEditingController();

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty) {
      context.read<CourseProvider>().addTag(text);
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    context.read<CourseProvider>().removeTag(tag);
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 700,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Course',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.cancel, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Image Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text.rich(
                            TextSpan(
                              text: 'Course Image ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                const TextSpan(
                                  text: '(Max 5MB -\nJPG, PNG)* ',
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black87),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('Choose File', style: TextStyle(color: Colors.black54)),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text('No File Choosen', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  // Dashed box equivalent
                                  Container(
                                    height: 100,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid), 
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 30),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Suggested Image Size: 5MB\n16/9 Aspect ratio',
                                    style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Introduction Video Section
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text.rich(
                            TextSpan(
                              text: 'Introduction Video ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                const TextSpan(
                                  text: '(Max 50MB - MP4)* ',
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal, fontSize: 12),
                                ),
                                WidgetSpan(
                                  child: Icon(Icons.info_outline, size: 14, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black87),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('Choose Video', style: TextStyle(color: Colors.black54)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Category
                    _buildLabel('Category*'),
                    _buildTextField('Select Category'),
                    const SizedBox(height: 16),
                    
                    // Course Name
                    _buildLabel('Course Name*'),
                    _buildTextField('Enter Name'),
                    const SizedBox(height: 16),

                    // Add Tutor
                    _buildTextField('Add Tutor'),
                    const SizedBox(height: 16),

                    // Add Course Tags
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            onSubmitted: (_) => _addTag(),
                            decoration: InputDecoration(
                              hintText: 'Add Course Tags',
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _addTag,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                    
                    Consumer<CourseProvider>(
                      builder: (context, provider, child) {
                        if (provider.tags.isEmpty) return const SizedBox.shrink();
                        
                        return Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: provider.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  border: Border.all(color: Colors.red.shade200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(tag, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => _removeTag(tag),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.redAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                      }
                    ),
                    
                    const SizedBox(height: 16),

                    // Price row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Price*'),
                              _buildTextField('Price', isItalic: true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Offer Price*'),
                              _buildTextField('Offer Price', isItalic: true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Tax*'),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Tax %',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontStyle: FontStyle.italic),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  suffixIcon: const Icon(Icons.percent, color: Colors.black87),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Apple prices
                    Row(
                      children: [
                        Expanded(child: _buildTextField('Apple Price*', isItalic: true)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField('Apple Offer Price*', isItalic: true)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Course Duration
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text('Course Duration*', style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Select Duration*', style: TextStyle(color: Colors.grey.shade400, fontStyle: FontStyle.italic)),
                                const Icon(Icons.arrow_drop_down, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(flex: 1, child: SizedBox()), // To match proportion
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Radio Grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildRadioRow('Live Classes?', true),
                              const SizedBox(height: 16),
                              _buildRadioRow('Available On PC?', false),
                              const SizedBox(height: 16),
                              _buildRadioRow('List on IOS?', false, showAlt: true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            children: [
                              _buildRadioRow('All Study Materials?', false),
                              const SizedBox(height: 16),
                              _buildRadioRow('Popular Course?', false),
                              const SizedBox(height: 16),
                              _buildRadioRow('Is Life Long?', true, showAlt: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            elevation: 0,
                          ),
                          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            elevation: 0,
                          ),
                          child: const Text('Add', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text.rich(
        TextSpan(
          text: text.replaceAll('*', ''),
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            if (text.contains('*'))
              const TextSpan(text: '*', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isItalic = false}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontStyle: isItalic ? FontStyle.italic : FontStyle.normal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildRadioRow(String label, bool isYesSelected, {bool showAlt = false}) {
    bool yesSelected = isYesSelected;
    if (showAlt) yesSelected = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Row(
          children: [
            _buildRadioButton(yesSelected, 'Yes'),
            const SizedBox(width: 24),
            _buildRadioButton(!yesSelected, 'No'),
          ],
        ),
      ],
    );
  }

  Widget _buildRadioButton(bool selected, String label) {
    return Row(
      children: [
        Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          color: selected ? Colors.blue.shade800 : Colors.black87,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
