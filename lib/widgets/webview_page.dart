import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../Repository/log_debugger.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  const WebViewPage({super.key, required this.title, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
    print(widget.title);

    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            LogDebugger.instance.d("WebView is loading (progress : $progress%)");
          },
          onPageStarted: (String url) {
            LogDebugger.instance.d("Page started with: $url");
          },
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},

        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

   setState(() {
     _controller = controller;
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(
         backgroundColor: Colors.indigo,
        title: Text(widget.title, style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
            onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(widget.title.toString()),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text('Are you sure that you want to exit this page?'),
                    ],
                  ),
                ),

                actions: <Widget>[
                  TextButton(
                    child: const Text('No, Cancel', style: TextStyle(color: Colors.black),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Yes, I want', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }),

      ),
      body:Column(
        children: [
          Expanded(
              child: WebViewWidget(controller: _controller)
          ),
        ],
      )
    );
  }
}
