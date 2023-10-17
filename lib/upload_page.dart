import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:image_cropper/image_cropper.dart';

Future<void> _pickImage() async {
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File pickedImageFile = File(pickedFile.path);

    // crop the image with a set diameter
    File croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImageFile.path,
      maxWidth: 224, // Set your desired diameter here
      maxHeight: 224, // Set your desired diameter here
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // Crop to a square
      compressQuality: 100, // 100 means no compression
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
      ),
    );
    // display the picked (and cropped) image
    // Image.file(pickedImageFile, width: 200, height: 200);    // select the full image
    Image.file(croppedFile!, width: 200, height: 200);           // select the cropped image
    }
}

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //code can be added from here
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Upload Page',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {
              // Call the _pickImage function when the button is pressed
              _pickImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor : Colors.blue, // Change background color to blue
              foregroundColor : Colors.white, // Change text color to white
            ),
            child: const Text('Pick Image'),
          ),
        ],
      )
    );
  }
}
