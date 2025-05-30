import 'package:flutter/material.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreenWeb extends StatefulWidget {
  const HelpScreenWeb({super.key});

  @override
  State<HelpScreenWeb> createState() => _HelpScreenWebState();
}

class _HelpScreenWebState extends State<HelpScreenWeb> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Progress is from 0 to 100
            setState(() {
              _progress = progress;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _progress = 100; // Ensure progress is 100 when done
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web error: $error');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://growk.io/faq_m.html'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GrowkAppBar(title: 'Frequently asked Questions', isBackBtnNeeded: true),
      body: Column(
        children: [
          if (_progress < 100)
            LinearProgressIndicator(value: _progress / 100),
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
