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
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BuildHeader(),
          _BuildAppContext(),
          _BuildImage(),
          _BuildAdditionalText(),
        ],
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
      color: const Color(0xFF3498db),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to My App',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Explore and enjoy our 3D Rotary Display!',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
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
        'Your app context text goes here...',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}

class _BuildImage extends StatelessWidget {
  const _BuildImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace 'YourImagePath' with the actual path or URL of your predefined image
    const String imagePath = 'assets/images/display_nieuw.png';

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Image.asset(
        imagePath,
        height: 200.0,
        fit: BoxFit.cover,
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
        'More details and information about the app can be added here...\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\ntester',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}