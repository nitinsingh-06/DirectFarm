import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(File?)? onImageSelected;

  const ImageUploadWidget({
    super.key,
    this.onImageSelected,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 18),

                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xFF075B47),
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(
                      context,
                      ImageSource.camera,
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: Color(0xFF075B47),
                  ),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(
                      context,
                      ImageSource.gallery,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (image == null) return;

    final File file = File(image.path);

    setState(() {
      _selectedImage = file;
    });

    widget.onImageSelected?.call(file);
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });

    widget.onImageSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Upload Button
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE0E7E4),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_a_photo_outlined,
                  size: 17,
                  color: Color(0xFF176B59),
                ),
                const SizedBox(height: 3),
                Text(
                  'Upload',
                  style: TextStyle(
                    fontSize: 7,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Selected Image
        if (_selectedImage != null)
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedImage!,
                  width: 58,
                  height: 58,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                right: -6,
                top: -6,
                child: GestureDetector(
                  onTap: _removeImage,
                  child: Container(
                    width: 19,
                    height: 19,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}