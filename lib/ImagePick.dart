import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerComponent extends StatefulWidget {
  final Function(File) onImageSelected;

  const ImagePickerComponent({super.key, required this.onImageSelected});

  @override
  _ImagePickerComponentState createState() => _ImagePickerComponentState();
}
const d_red = Colors.red;

class _ImagePickerComponentState extends State<ImagePickerComponent> {
  String? imageSrc;
  File? photo;
  final String _errorMessage = '';

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imagePermanent = await saveImagePermanently(image.path);

        setState(() {
          photo = imagePermanent;
          imageSrc = imagePermanent.path;
        });

        // Callback to the parent widget with the selected image
        widget.onImageSelected(imagePermanent);
      } else {
        throw Exception('Image non téléchargée');
      }
    } on PlatformException catch (e) {
      debugPrint('Erreur lors du téléchargement de l\'image : $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _pickImage,
      child: const Text(
        'Sélectionner une image',
        style: TextStyle(color: d_red),
      ),
    );
  }
}


// Future<File> saveImagePermanently(String imagePath) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final name = path.basename(imagePath);
//   final image = File('${directory.path}/$name');

//   return File(imagePath).copy(image.path);
// }

// Future<File?> getImage(ImageSource source) async {
//   final image = await ImagePicker().pickImage(source: source);
//   if (image == null) return null;

//   return File(image.path);
// }

// Future<void> _pickImage(ImageSource source) async {
//   final image = await getImage(source);
//   if (image != null) {
//     setState(() {
//       this.photo = image;
//       imageSrc = image.path;
//     });
//   }
// }
