import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class StreamingPage extends StatefulWidget {
  const StreamingPage({Key? key}) : super(key: key);

  @override
  _StreamingPageState createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late CameraController _controller;
  TextEditingController _streamKeyController = TextEditingController();

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

        if (response.statusCode == 200) {
          print('Stream started successfully');
        } else {
          print('Error starting stream: ${response.statusCode}');
        }
      } catch (e) {
        print('Exception starting stream: $e');
      }
    } else {
      print('Camera is not initialized.');
    }
  }

  void _openTwitchAuthPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an action"),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _openTwitchAuth();
                },
                child: Text('Open Twitch Authentication'),
              ),
              SizedBox(height: 16),
               ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _launchGoogle();
                },
                child: Text('Open Google'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _openYouTube();
                },
                child: Text('Open YouTube'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _openTwitchWebPage();
                },
                child: Text('Open Twitch Web Page'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchGoogle() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GoogleSearchPage(),
    ));
  }

  void _openYouTube() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WebViewPage('https://www.youtube.com'),
    ));
  }

  void _openTwitchWebPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => WebViewPage('https://www.twitch.tv/specialisatie_project'),
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
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Streaming Page'),
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
                    decoration: InputDecoration(labelText: 'Stream Key'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _openTwitchAuthPage,
                    child: Text('Start Streaming'),
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

  WebViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

// ... rest of the code remains unchanged ...


class GoogleSearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Search'),
      ),
      body: WebView(
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

  TwitchLoginScreen({
    required this.clientId,
    required this.redirectUri,
    required this.scope,
    required this.onAccessTokenReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Twitch Login'),
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
