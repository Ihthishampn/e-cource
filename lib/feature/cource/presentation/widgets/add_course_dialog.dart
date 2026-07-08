
import 'package:e_cource/feature/cource/data/model/course_model.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_provider.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/apple_pricing_row.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/category_drop_down.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/course_image_picker.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/course_option_grid.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_action.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_header.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_section.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/dilogue_text_field.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/duration_drop_down.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/price_row.dart';
import 'package:e_cource/feature/cource/presentation/widgets/course_add_widgets/tag_input_section.dart';
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/build_search_keywords.dart';
import 'package:e_cource/general/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';






///  provides CourseProvider to the subtree.
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
                          onImagePicked: (bytes, _, _, _) {
                            setState(() => _imageBytes = bytes);
                          },
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Category',
                        required: true,
                        child: CategoryDropdown(cp: cp),
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
                        child: PricingRow(
                          priceController: _priceController,
                          offerPriceController: _offerPriceController,
                          taxController: _taxController,
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Apple Pricing',
                        required: true,
                        child: ApplePricingRow(
                          applePriceController: _applePriceController,
                          appleOfferPriceController: _appleOfferPriceController,
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Course Duration',
                        required: true,
                        child: DurationDropdown(
                          selected: _selectedDuration,
                          onChanged: (val) =>
                              setState(() => _selectedDuration = val),
                        ),
                      ),
                      _divider(),
                      DialogSectionRow(
                        label: 'Course Options',
                        child: CourseOptionsGrid(cp: cp),
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





