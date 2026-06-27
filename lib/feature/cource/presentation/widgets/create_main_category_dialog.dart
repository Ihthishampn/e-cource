import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:e_cource/general/enums/app_state.dart';
import 'package:e_cource/general/widgets/custom_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:e_cource/feature/cource/presentation/provider/course_firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateMainCategoryDialog extends StatefulWidget {
  const CreateMainCategoryDialog({super.key});

  @override
  State<CreateMainCategoryDialog> createState() =>
      _CreateMainCategoryDialogState();
}

class _CreateMainCategoryDialogState extends State<CreateMainCategoryDialog> {
  final TextEditingController nameController = TextEditingController();

  Uint8List? _imageBytes;
  int? _imageWidth;
  int? _imageHeight;
  double? _fileSizeMB;


  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final sizeInMB = bytes.lengthInBytes / (1024 * 1024);

      // Decode image to get dimensions
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final ratio = image.width / image.height;
      final isAspectValid = (ratio - 16 / 9).abs() < 0.2;

      // Reject if requirements not met
      if (sizeInMB > 5.0) {
        showToast(msg: "Image too large (${sizeInMB.toStringAsFixed(1)}MB). Max allowed is 5MB.");
        return;
      }
      if (!isAspectValid) {
        showToast(msg: "Image must be 16:9 aspect ratio. Got ${image.width}×${image.height}.");
        return;
      }

      setState(() {
        _imageBytes = bytes;
        _fileSizeMB = sizeInMB;
        _imageWidth = image.width;
        _imageHeight = image.height;
      });
    }
  }

  Future<void> _handleAdd() async {
    if (nameController.text.trim().isEmpty || _imageBytes == null) {
      showToast(msg: "Name and image are required");
      return;
    }

    await context.read<CourseFirebaseProvider>().handleAddCatrgory(
      name: nameController.text,
      imageFile: _imageBytes!,
    );

    if (!mounted) return;

    final state = context.read<CourseFirebaseProvider>().addCategoryState;
    if (state == AppState.success) {
      showToast(msg: "Category added successfully");
      Navigator.pop(context);
    } else if (state == AppState.error) {
      showToast(msg: context.read<CourseFirebaseProvider>().addCatgoryerror ?? "Failed to add category");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 600,
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
                    'Add Main Category',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.cancel, color: Colors.white),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text.rich(
                            TextSpan(
                              text: 'Thumbnail Image',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black87),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Choose File',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _imageBytes != null ? 'File Selected' : 'No File Chosen',
                                  style: TextStyle(
                                    color: _imageBytes != null ? Colors.green : Colors.grey,
                                  ),
                                ),
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
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: _imageBytes != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.memory(
                                            _imageBytes!,
                                            height: 100,
                                            width: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.image_outlined,
                                            color: Colors.grey.shade400,
                                            size: 30,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                if (_imageBytes == null)
                                  Text(
                                    'Max Size: 5MB\n16:9 Aspect Ratio',
                                    style: TextStyle(
                                      color: Colors.blue.shade300,
                                      fontSize: 12,
                                    ),
                                  )
                                else
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Size: ${_fileSizeMB!.toStringAsFixed(2)} MB',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            '$_imageWidth × $_imageHeight',
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Category Name Field
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Category Name',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Consumer<CourseFirebaseProvider>(
                        builder: (context, provider, _) {
                          final isLoading = provider.addCategoryState == AppState.loading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : _handleAdd,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 16,
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Add',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
