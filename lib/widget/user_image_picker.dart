import 'dart:io';
import 'package:chatapp/widget/pick_source.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onSelectedImage});

  final void Function(File pickedimage) onSelectedImage;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePicker();
  }
}

class _UserImagePicker extends State<UserImagePicker> {
  ImageSource? _type;
  File? _pickedImage;

  void _pickImage() async {
    final response = await showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return PickSource(
            onType: (ImageSource type) {
              _type = type;
            },
          );
        });
    final imagePicker = ImagePicker();

    if (_type == null) {
      return;
    }

    final image = await imagePicker.pickImage(
        source: _type!, imageQuality: 100, maxWidth: 150);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
      widget.onSelectedImage(_pickedImage!);
      return;
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: Text(
            _pickedImage == null ? 'Add Image' : 'Take Picture again.',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          icon: const Icon(Icons.image),
        )
      ],
    );
  }
}
