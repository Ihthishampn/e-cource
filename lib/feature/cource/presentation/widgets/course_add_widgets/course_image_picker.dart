import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:e_cource/general/widgets/custom_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class CourseImagePicker extends StatefulWidget {
  const CourseImagePicker({
    super.key,
    required this.onImagePicked,
  });

  /// Called with the raw bytes once a valid image is selected.
  final void Function(Uint8List bytes, double sizeMB, int width, int height)
      onImagePicked;

  @override
  State<CourseImagePicker> createState() => _CourseImagePickerState();
}

class _CourseImagePickerState extends State<CourseImagePicker> {
  Uint8List? _imageBytes;
  int? _imageWidth;
  int? _imageHeight;
  double? _fileSizeMB;

  Future<void> _pick() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) return;

    final bytes = result.files.single.bytes!;
    final sizeInMB = bytes.lengthInBytes / (1024 * 1024);

    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final ratio = image.width / image.height;
    final isAspectValid = (ratio - 16 / 9).abs() < 0.2;

    if (sizeInMB > 5.0) {
      showToast(
        msg:
            'Image too large (${sizeInMB.toStringAsFixed(1)} MB). Max allowed is 5 MB.',
      );
      return;
    }
    if (!isAspectValid) {
      showToast(
        msg:
            'Image must be 16:9 aspect ratio. Got ${image.width}×${image.height}.',
      );
      return;
    }

    setState(() {
      _imageBytes = bytes;
      _fileSizeMB = sizeInMB;
      _imageWidth = image.width;
      _imageHeight = image.height;
    });

    widget.onImagePicked(bytes, sizeInMB, image.width, image.height);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _ChooseFileButton(onTap: _pick),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImagePreview(imageBytes: _imageBytes),
            const SizedBox(width: 16),
            if (_imageBytes == null)
              Text(
                'Max Size: 5MB\n16:9 Aspect Ratio',
                style: TextStyle(color: Colors.blue.shade300, fontSize: 12),
              )
            else
              _ImageInfoColumn(
                sizeMB: _fileSizeMB!,
                width: _imageWidth!,
                height: _imageHeight!,
              ),
          ],
        ),
      ],
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _ChooseFileButton extends StatelessWidget {
  const _ChooseFileButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('Choose File',
            style: TextStyle(color: Colors.black54)),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imageBytes});
  final Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: imageBytes != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(imageBytes!,
                  height: 100, width: 150, fit: BoxFit.cover),
            )
          : Center(
              child: Icon(Icons.image_outlined,
                  color: Colors.grey.shade400, size: 30),
            ),
    );
  }
}

class _ImageInfoColumn extends StatelessWidget {
  const _ImageInfoColumn({
    required this.sizeMB,
    required this.width,
    required this.height,
  });

  final double sizeMB;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow('Size: ${sizeMB.toStringAsFixed(2)} MB'),
        const SizedBox(height: 4),
        _InfoRow('$width × $height'),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}