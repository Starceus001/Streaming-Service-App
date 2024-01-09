import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class StreamingPage extends StatefulWidget {
  const StreamingPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late CameraController _controller;
  final TextEditingController _streamKeyController = TextEditingController();

  String clientId = '1k07v26rojuhagzfrahvzqr8d37989';
  String redirectUri = 'http://localhost:0001/oauth';
  String scope = 'channel:manage:broadcast';

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
    _streamKeyController.text = 'live_993744240_DufYHsGijuzj1bYQ4TFNR0aK3eHfXN';
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamKeyController.dispose();
    super.dispose();
  }

  Future<void> _startStreaming(String accessToken) async {
    String streamKey = _streamKeyController.text;

    if (_controller.value.isInitialized) {
      try {
        final response = await http.post(
          Uri.parse('https://api.twitch.tv/helix/streams'),
          headers: {
            'Client-ID': clientId,
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: '{"title": "My Twitch Stream", "stream_key": "$streamKey"}',
        );
      } catch (e) {
        print('Exception starting stream: $e');
      }
    }
  }

  void _openTwitchAuthPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an action"),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _openTwitchAuth();
                },
                child: const Text('Open Twitch Authentication'),
              ),
              const SizedBox(height: 16),
               ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _launchGoogle();
                },
                child: const Text('Open Google'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _openYouTube();
                },
                child: const Text('Open YouTube'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _openTwitchWebPage();
                },
                child: const Text('Open Twitch Web Page'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchGoogle() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const GoogleSearchPage(),
    ));
  }

  void _openYouTube() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const WebViewPage('https://www.youtube.com'),
    ));
  }

  void _openTwitchWebPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const WebViewPage('https://www.twitch.tv/specialisatie_project'),
    ));
  }

  void _openTwitchAuth() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TwitchLoginScreen(
        clientId: clientId,
        redirectUri: redirectUri,
        scope: scope,
        onAccessTokenReceived: _startStreaming,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaming Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _streamKeyController,
                    decoration: const InputDecoration(labelText: 'Stream Key'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _openTwitchAuthPage,
                    child: const Text('Start Streaming'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  const WebViewPage(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web View'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class GoogleSearchPage extends StatelessWidget {
  const GoogleSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Search'),
      ),
      body: const WebView(
        initialUrl: 'https://www.google.com',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

class TwitchLoginScreen extends StatelessWidget {
  final String clientId;
  final String redirectUri;
  final String scope;
  final Function(String) onAccessTokenReceived;

  const TwitchLoginScreen({super.key, 
    required this.clientId,
    required this.redirectUri,
    required this.scope,
    required this.onAccessTokenReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitch Login'),
      ),
      body: WebView(
        initialUrl:
            'https://id.twitch.tv/oauth2/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=token&scope=$scope',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(redirectUri)) {
            Uri uri = Uri.parse(request.url);
            if (uri.fragment.contains('access_token=')) {
              String accessToken = uri.fragment
                  .substring(uri.fragment.indexOf('access_token=') + 13);
              accessToken = accessToken.substring(0, accessToken.indexOf('&'));

              onAccessTokenReceived(accessToken);

              Navigator.pop(context);

              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
