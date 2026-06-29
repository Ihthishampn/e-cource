
import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_provider.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/course_image_picker.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_action.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_header.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_section.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_text_field.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/tag_input_section.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/build_search_keywords.dart';
import 'package:e_cource/general/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'course_add_widgets/yes_not_widget.dart';



const List<String> _durations = [
  '1 Month',
  '3 Months',
  '6 Months',
  '1 Year',
];

/// Outer wrapper — provides CourseProvider to the subtree.
class AddCourseDialog extends StatelessWidget {
  const AddCourseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const _AddCourseDialogBody(),
    );
  }
}

class _AddCourseDialogBody extends StatefulWidget {
  const _AddCourseDialogBody();

  @override
  State<_AddCourseDialogBody> createState() => _AddCourseDialogBodyState();
}

class _AddCourseDialogBodyState extends State<_AddCourseDialogBody> {
  final _courseNameController = TextEditingController();
  final _tutorController = TextEditingController();
  final _tagController = TextEditingController();
  final _priceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _taxController = TextEditingController();
  final _applePriceController = TextEditingController();
  final _appleOfferPriceController = TextEditingController();

  Uint8List? _imageBytes;
  String? _selectedDuration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fp = context.read<CourseFirebaseProvider>();
      if (fp.mcList.isEmpty) fp.handleFetchMainCategory();
    });
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _tutorController.dispose();
    _tagController.dispose();
    _priceController.dispose();
    _offerPriceController.dispose();
    _taxController.dispose();
    _applePriceController.dispose();
    _appleOfferPriceController.dispose();
    super.dispose();
  }

  void _addTag() {
    final text = _tagController.text.trim();
    if (text.isNotEmpty) {
      context.read<CourseProvider>().addTag(text);
      _tagController.clear();
    }
  }

  Future<void> _handleAdd() async {
    final cp = context.read<CourseProvider>();

    if (_imageBytes == null) {
      showToast(msg: 'Course image is required');
      return;
    }
    if (cp.selectedCategory == null) {
      showToast(msg: 'Please select a category');
      return;
    }
    if (_courseNameController.text.trim().isEmpty) {
      showToast(msg: 'Course name is required');
      return;
    }
    if (_selectedDuration == null) {
      showToast(msg: 'Please select a duration');
      return;
    }

    final model = CourseModel(
      id: '',
      name: _courseNameController.text.trim(),
      image: '',
      categoryId: cp.selectedCategory!.id,
      categoryName: cp.selectedCategory!.name,
      tutor: _tutorController.text.trim(),
      tags: List<String>.from(cp.tags),
      price: double.tryParse(_priceController.text) ?? 0,
      offerPrice: double.tryParse(_offerPriceController.text) ?? 0,
      tax: double.tryParse(_taxController.text) ?? 0,
      applePrice: double.tryParse(_applePriceController.text) ?? 0,
      appleOfferPrice: double.tryParse(_appleOfferPriceController.text) ?? 0,
      duration: _selectedDuration!,
      hasLiveClasses: cp.hasLiveClasses,
      hasStudyMaterials: cp.hasStudyMaterials,
      availableOnPC: cp.availableOnPC,
      isPopular: cp.isPopular,
      listOnIOS: cp.listOnIOS,
      isLifeLong: cp.isLifeLong,
      keywords: keywordsBuilder(_courseNameController.text.trim()),
    );

    await context
        .read<CourseFirebaseProvider>()
        .handleAddCourse(model: model, imageFile: _imageBytes!);

    if (!mounted) return;

    final fp = context.read<CourseFirebaseProvider>();
    if (fp.addCourseState == AppState.success) {
      showToast(msg: 'Course added successfully');
      Navigator.pop(context);
    } else if (fp.addCourseState == AppState.error) {
      showToast(msg: fp.addCourseerror ?? 'Failed to add course');
    }
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
            DialogHeader(
              title: 'Add Course',
              onClose: () => Navigator.pop(context),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Consumer<CourseProvider>(
                  builder: (context, cp, _) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DialogSectionRow(
                        label: 'Course Image',
                        required: true,
                        hint: '(Max 5MB – JPG, PNG)',
                        child: CourseImagePicker(
                          onImagePicked: (bytes, _, __, ___) {
                            setState(() => _imageBytes = bytes);
                          },
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Category',
                        required: true,
                        child: _CategoryDropdown(cp: cp),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Course Name',
                        required: true,
                        child: DialogTextField(
                          controller: _courseNameController,
                          hint: 'Enter course name',
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Tutor',
                        child: DialogTextField(
                          controller: _tutorController,
                          hint: 'Add tutor name',
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Course Tags',
                        child: TagInputSection(
                          controller: _tagController,
                          tags: cp.tags,
                          onAdd: _addTag,
                          onRemove: cp.removeTag,
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Pricing',
                        required: true,
                        child: _PricingRow(
                          priceController: _priceController,
                          offerPriceController: _offerPriceController,
                          taxController: _taxController,
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Apple Pricing',
                        required: true,
                        child: _ApplePricingRow(
                          applePriceController: _applePriceController,
                          appleOfferPriceController: _appleOfferPriceController,
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Course Duration',
                        required: true,
                        child: _DurationDropdown(
                          selected: _selectedDuration,
                          onChanged: (val) =>
                              setState(() => _selectedDuration = val),
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Course Options',
                        child: _CourseOptionsGrid(cp: cp),
                      ),
                      const SizedBox(height: 32),
                      Consumer<CourseFirebaseProvider>(
                        builder: (context, fp, _) => DialogActions(
                          onCancel: () => Navigator.pop(context),
                          onConfirm: _handleAdd,
                          isLoading: fp.addCourseState == AppState.loading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Divider(height: 1, color: Color(0xFFEEEEEE)),
      );
}

// ── Local-scope small widgets (tightly coupled to this dialog) ────────────────

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({required this.cp});
  final CourseProvider cp;

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseFirebaseProvider>(
      builder: (context, fp, _) {
        if (fp.getCategoryState == AppState.loading) {
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Loading categories...',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        final categories = fp.mcList;

        return DropdownButtonFormField<String>(
          value: cp.selectedCategory?.id,
          isExpanded: true,
          hint: Text(
            'Select Category',
            style: TextStyle(
                color: Colors.grey.shade400, fontStyle: FontStyle.italic),
          ),
          decoration: _dropdownDecoration(),
          items: categories
              .map((c) =>
                  DropdownMenuItem<String>(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: (id) {
            if (id == null) return;
            cp.setSelectedCategory(categories.firstWhere((c) => c.id == id));
          },
        );
      },
    );
  }
}

class _DurationDropdown extends StatelessWidget {
  const _DurationDropdown({required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      isExpanded: true,
      hint: Text(
        'Select Duration',
        style: TextStyle(
            color: Colors.grey.shade400, fontStyle: FontStyle.italic),
      ),
      decoration: _dropdownDecoration(),
      items: _durations
          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({
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

class _ApplePricingRow extends StatelessWidget {
  const _ApplePricingRow({
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

class _CourseOptionsGrid extends StatelessWidget {
  const _CourseOptionsGrid({required this.cp});
  final CourseProvider cp;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Expanded(
            child: YesNoRadioRow(
              label: 'Live Classes?',
              value: cp.hasLiveClasses,
              onChanged: cp.toggleLiveClasses,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: YesNoRadioRow(
              label: 'Study Materials?',
              value: cp.hasStudyMaterials,
              onChanged: cp.toggleStudyMaterials,
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: YesNoRadioRow(
              label: 'Available On PC?',
              value: cp.availableOnPC,
              onChanged: cp.toggleAvailableOnPC,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: YesNoRadioRow(
              label: 'Popular Course?',
              value: cp.isPopular,
              onChanged: cp.togglePopular,
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Row(children: [
          Expanded(
            child: YesNoRadioRow(
              label: 'List on iOS?',
              value: cp.listOnIOS,
              onChanged: cp.toggleListOnIOS,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: YesNoRadioRow(
              label: 'Is Life Long?',
              value: cp.isLifeLong,
              onChanged: cp.toggleLifeLong,
            ),
          ),
        ]),
      ],
    );
  }
}


InputDecoration _dropdownDecoration() {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  );
}