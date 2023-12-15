import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class BackgroundContainer extends StatelessWidget {
  final Widget child;

  const BackgroundContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A233E), Color(0xFF379994)],
        ),
      ),
      child: SafeArea(
        child: child,
      ),
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? pickedImageFile;
  img.Image? croppedImage;
  img.Image? tempCroppedImage;

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          pickedImageFile = File(pickedFile.path);
        });

        _cropImage();
      }
    } catch (e) {
      Text("Error picking image: $e");
    }
  }

  void _cropImage() {
    if (pickedImageFile != null) {
      final rawImage = img.decodeImage(File(pickedImageFile!.path).readAsBytesSync())!;

      const double targetSize = 224.0;

      tempCroppedImage = img.copyCropCircle(rawImage, radius: targetSize.toInt());

      _showConfirmationDialog();
    }
  }

void _showConfirmationDialog() {
  const double targetSize = 224.0;
  const double borderWidth = 2.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final currentContext = context;

      return AlertDialog(
        title: const Text(
          'Confirm Image',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF074A6B),
        content: Column(
          children: [
            if (tempCroppedImage != null)
              Container(
                width: targetSize + borderWidth * 2,
                height: targetSize + borderWidth * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: borderWidth),
                ),
                child: Image.memory(
                  Uint8List.fromList(img.encodePng(tempCroppedImage!)),
                  width: targetSize,
                  height: targetSize,
                ),
              ),
            const Text(
              'The selected image will be displayed as shown above, would you like to continue?',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Exo',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(currentContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _confirmCrop();
              Navigator.of(currentContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

  void _confirmCrop() {
    if (pickedImageFile != null && tempCroppedImage != null) {
      croppedImage = tempCroppedImage;

      File(pickedImageFile!.path).writeAsBytesSync(img.encodePng(croppedImage!));

      setState(() {});
    } else {
      const Text("Saving cropped image failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    const double targetSize = 224.0;

    return BackgroundContainer(
      child: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Upload Page',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Exo',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Welcome to the "Upload" page, here you have acces to a button which will open the device gallery. From here, you can select an image which will be shaped to fit the specifications of the display that the image will eventually be sent to. For the purpose of this app, we will be cutting the image into a circle with the center of this circle at the center of thie provided image with a specified diameter of 224 pixels representing the 224 LEDs on our circular 3D Rotary Display.\n\nThe app will give you a preview of what the image will look like before you submit it. When the image has been submitted, it will be displayed in the circular space on this page as well as sent to the Twitch website where it will be shown. When submitting a new image, it will overwrite the old one.',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Exo',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                width: targetSize,
                height: targetSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular((targetSize + 32.0) / 2),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (croppedImage != null)
                      Image.memory(
                        Uint8List.fromList(img.encodePng(croppedImage!)),
                        width: targetSize,
                        height: targetSize,
                      ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Select Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}