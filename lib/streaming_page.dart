import 'package:flutter/material.dart';
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

  // Twitch API-gegevens
  String clientId = '1k07v26rojuhagzfrahvzqr8d37989';
  String clientSecret = 'a5bdn6uo9pq2rwfzm9rk6jnc3kf8vg';
  String twitchUrl = 'http://localhost:0001/oauth';

  @override
  void initState() {
    super.initState();
    // Get a list of available cameras.
    availableCameras().then((cameras) {
      // Initialize the camera controller
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamKeyController.dispose();
    super.dispose();
  }

  Future<String> getTwitchAccessToken(String clientId, String clientSecret) async {
    try {
      final response = await http.post(
        Uri.parse('$twitchUrl/token'), // Twitch OAuth URL
        body: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response and return the access token
        return response.body;
      } else {
        // Handle errors
        print('Error getting Twitch access token: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      // Handle exceptions
      print('Exception getting Twitch access token: $e');
      return '';
    }
  }

  Future<void> startTwitchStream(String clientId, String accessToken, String streamKey) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.twitch.tv/helix/streams'),
        headers: {
          'Client-ID': clientId,
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: '{"title": "My Twitch Stream", "game_id": "game_id_here"}',
      );

      if (response.statusCode == 200) {
        // Stream started successfully
        print('Stream started successfully');
      } else {
        // Handle errors
        print('Error starting stream: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception starting stream: $e');
    }
  }

  void _startStreaming() async {
    // Get the stream key from the text field
    String streamKey = _streamKeyController.text;

    // Get the Twitch access token
    String accessToken = await getTwitchAccessToken(clientId, clientSecret);

    // Start the Twitch stream
    await startTwitchStream(clientId, accessToken, streamKey);
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
                    onPressed: _startStreaming,
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
