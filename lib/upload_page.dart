import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? pickedImageFile;
  img.Image? croppedImage;
  img.Image? tempCroppedImage;

  // pick the image from the gallery
  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          pickedImageFile = File(pickedFile.path);
        });

        // call the cropping function
        _cropImage();
      }
    } catch (e) {
      Text("Error picking image: $e");
    }
  }

// crop the image to show and ask for confirmation
void _cropImage() {
  if (pickedImageFile != null) {
    // load the picked image
    final rawImage = img.decodeImage(File(pickedImageFile!.path).readAsBytesSync())!;

    // set targetSize (when done, get size from settings page)
    const double targetSize = 224.0;

    // crop the image to a circle
    tempCroppedImage = img.copyCropCircle(rawImage, radius: targetSize.toInt());

    // show the confirmation dialog
    _showConfirmationDialog();
  }
}

// give a popup where the user can accept or deny the selected (cropped) image
void _showConfirmationDialog() {
  // set targetSize (when done, get size from settings page)
    const double targetSize = 224.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final currentContext = context;

      return AlertDialog(
        title: const Text('Confirm Image'),
        content: Column(
          children: [
            if (tempCroppedImage != null)
              Image.memory(
                Uint8List.fromList(img.encodePng(tempCroppedImage!)),
                width: targetSize,
                height: targetSize,
              ),
            const Text('The selected image will be displayed as shown above, would you like to continue?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(currentContext).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _confirmCrop();
              Navigator.of(currentContext).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

// the user confirms the cropped image, send it to the webserver
void _confirmCrop() {
  if (pickedImageFile != null && tempCroppedImage != null) {

    // if user confirms, save the cropped image to the main variable
    croppedImage = tempCroppedImage;

    // save the cropped image back to the file
    File(pickedImageFile!.path).writeAsBytesSync(img.encodePng(croppedImage!));

    // trigger a rebuild of the widget tree
    setState(() {});

    // Perform further actions with the cropped file (croppedImage now holds the final cropped image!)
// "Brent Code" Add brent his code here to send croppedImage to the selected webserver, give a problem message if no server has been selected in settings
    // For example, save the cropped file path or upload it to a server
    // finalVariable = pickedImageFile;
    // performFurtherAction();
    // You can show a confirmation message or navigate to the next screen here
    // print("Cropped image confirmed and stored: ${pickedImageFile!.path}");
  } else {
    // handle the case where cropping or saving failed
    const Text("Saving cropped image failed");
  }
}

  @override
  Widget build(BuildContext context) {
    // set targetSize (when done, get size from settings page)
    const double targetSize = 224.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Upload Page',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          // button to pick and crop an image
          ElevatedButton(
            onPressed: () {
              // call the _pickImage function when the button is pressed
              _pickImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Select Image'),
          ),
          // display the final cropped image in the app
          if (croppedImage != null)
            Column(
              children: [
                Image.memory(
                  Uint8List.fromList(img.encodePng(croppedImage!)),
                  width: targetSize,
                  height: targetSize,
                ),
              ],
            ),
        ],
      ),
    );
  }
}