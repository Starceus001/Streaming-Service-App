// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     //code can be added from here
//     return const Center(
//       child: Text('Home Page',
//           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//     );
//   }
// }



import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A233E), Color(0xFF379994)],
          ),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BuildHeader(),
            _BuildAppContext(),
            _BuildImage(),
            _BuildAdditionalText(),
          ],
        ),
      ),
    );
  }
}

class _BuildHeader extends StatelessWidget {
  const _BuildHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF192442),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to HoloStream',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontFamily: 'Exo',
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Please explore, enjoy and stay as long as you like in our 3D Rotary Display App!',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontFamily: 'Exo',
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildAppContext extends StatelessWidget {
  const _BuildAppContext({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Thank you for trying out our app.\nOur names are brent Nieuwland and Guido Annema and we are fourth year Electrical Engineering student.\n\nWe have created this app for the sole purpose of streaming images from the gallery of this device, as well as the live image of the available camera to a website called Twitch!\n\n This app has been created to adhere to the specifications set forth from our project "App Ontwikkeling", a class we have followed where we learned how to create a flutter/dart based app using device applications like the camera.\n\nThe standard streaming to a Twitch website has been designed to, in the future, be used to stream images and a live camera feed to a 3D Rotary Display that we have created during one of our other classes. As this will fall outside of our scope, this app will provide a basis for a future group of students to set forth our mission to develop a new Rotary Display that will be used in catching the attention of potential new students.',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'Exo',
        ),
      ),
    );
  }
}

class _BuildImage extends StatelessWidget {
  const _BuildImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String imagePath = 'assets/images/display_nieuw.png';

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 35,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: Image.asset(
          imagePath,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _BuildAdditionalText extends StatelessWidget {
  const _BuildAdditionalText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Now for a quick rundown through our app, as we will provide a detailed rundown of each page on the page itself. At the top left hand side of the screen, you will find a hamburger style menu that will lead you to further layers in our app.\n\nOur first stop will be the "Upload" page where you have acces to a button which will acces the device gallery. From here, you can select an image which will be shaped to fit the specifications of the display that the image will eventually be sent to. For the purpose of this app, we will be cutting the image into a circle with a specified diameter of 224 pixels representing the 224 LEDs on our circular 3D Rotary Display.\nThe app will give you a preview of what the image will look like before you submit it. When the image has been submitted, it will be displayed on this page as well as sent to the Twitch website where it will be shown. When submitting a new image, it will overwrite the old one.\n\nOn the "Streaming" page, you will be able to open the front camera of this device and a live image of that camera will appear in the app. This image will be cut with the same parameters as the uploading and will be sent to the Twitch website when selected. This will overwrite any images previously sent to the Twitch website.',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontFamily: 'Exo',
        ),
      ),
    );
  }
}