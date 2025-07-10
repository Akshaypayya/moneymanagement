import 'package:webview_flutter/webview_flutter.dart';
import '../../../views.dart';

class HelpScreenWeb extends ConsumerStatefulWidget {
  const HelpScreenWeb({super.key});

  @override
  ConsumerState<HelpScreenWeb> createState() => _HelpScreenWebState();
}

class _HelpScreenWebState extends ConsumerState<HelpScreenWeb> {
  WebViewController? _controller;
  int _progress = 0;

  WebViewController _createWebViewController(bool isDark) {
    final controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _progress = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web error: $error');
          },
        ),
      )
      ..loadRequest(
        Uri.parse(
          isDark
              ? "https://www.growk.io/faq_md.html"
              : "https://growk.io/faq_m.html",
        ),
      );
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    _controller ??= _createWebViewController(isDark);

    return Scaffold(
      backgroundColor: AppColors.current(isDark).background,
      appBar: GrowkAppBar(title: 'Frequently asked Questions', isBackBtnNeeded: true),
      body: Column(
        children: [
          if (_progress < 100)
            LinearProgressIndicator(value: _progress / 100),
          Expanded(
            child: WebViewWidget(controller: _controller!),
          ),
        ],
      ),
    );
  }
}
