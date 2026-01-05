import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'homepage.dart';
import 'search.dart';

class YouTubePage extends StatefulWidget {
  const YouTubePage({super.key});

  @override
  State<YouTubePage> createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // ✅ Set platform implementation
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance == null) {
      if (WebViewPlatform.instance == null) {
        if (WebViewPlatform.instance == null) {
          // Android
          WebViewPlatform.instance = AndroidWebViewPlatform();
        }
        // iOS
        if (WebViewPlatform.instance == null) {
          WebViewPlatform.instance = WebKitWebViewPlatform();
        }
      }
    }

    // ✅ Create controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://www.youtube.com/?theme=dark"));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(85.0), // 👈 Set desired AppBar height
        child: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Container(
            padding: EdgeInsets.only(top: 25.0),

            child: Text(
              "Music",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40, // 👈 Large text size
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(bottom: 12, left: 16, right: 16),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                    color: Color(0xFF2356D8),

                    // outline color
                    width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.library_music, color: Colors.white),
                        SizedBox(height: 4),
                        Text("My Music", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  HomePage(),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search, color: Colors.white),
                        SizedBox(height: 4),
                        Text("Search", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  SearchPage(),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.video_collection_rounded, color: Colors.white),
                        SizedBox(height: 4),
                        Text("YouTube", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  YouTubePage(),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ),
        ],
      ),


    );
  }
}
