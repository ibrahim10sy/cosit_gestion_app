import 'dart:io';

import 'package:cosit_gestion/DelayAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}
const d_red = Colors.red;
List<String> list = <String>[
  'Directeur',
  'Comptable',
  'Sécretaire',
  'Développeur',
  'Développeuse'
];
class _TestState extends State<Test> {
    String defaultRole = "";
     String? imageSrc;
  File? photo;
    Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imagePermanent = await saveImagePermanently(image.path);

        setState(() {
          photo = imagePermanent;
          imageSrc = imagePermanent.path;
        });
      } else {
        throw Exception('Image non télécharger');
      }
    } on PlatformException catch (e) {
      debugPrint('erreur lors de téléchargement de l\'image : $e');
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 118),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: DelayedAnimation(
              delay: 2000,
              child: Center(
                child: (photo != null)
                    ? Image.file(photo!)
                    : Image.asset('assets/images/logo.png'),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 5),
          decoration: const BoxDecoration(
              // color: Color(0xfff5f8fd),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 45),
                backgroundColor: const Color(0xff2ffffff), // Button color
              ),
              onPressed: () {
                _pickImage();
              },
              child: const Text(
                'Sélectionner une photo de profil',
                style: TextStyle(
                  color: d_red,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
         Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width *
                0.05, // 10% padding on each side
            vertical: 10,
          ),
          child: DropdownMenu<String>(
            width: MediaQuery.of(context).size.width * 0.9,
            inputDecorationTheme: const InputDecorationTheme(
              contentPadding: EdgeInsets.all(18),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
            ),
            initialSelection: list.first,
            onSelected: (String? value) {
              setState(() {
                defaultRole = value!;
              });
            },
            dropdownMenuEntries:
                list.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
        ),
      ]),
    );
  }
}