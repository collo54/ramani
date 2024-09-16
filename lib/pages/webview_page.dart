import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/colors.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key, required this.uri});
  final String uri;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  var loadingPercentage = 0;
  late final WebViewController controller;
  RegExp pattern = RegExp(r'^https');

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(widget.uri),
      );
  }

  // 'https://flutter.dev'

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kwhite25525525510,
        leadingWidth: 56,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.multiply,
            color: kblack00008,
          ),
        ),
        centerTitle: false,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                'Privacy policy',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    letterSpacing: 0,
                    color: kblack00008,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.lock,
                    color: kblack00005,
                    size: 14,
                  ),
                ),
                Expanded(
                  child: Text(
                    pattern.hasMatch(widget.uri)
                        ? widget.uri.substring(8)
                        : widget.uri.substring(7),
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        letterSpacing: 0,
                        color: kblack00008,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottom: loadingPercentage < 100
            ? PreferredSize(
                preferredSize: Size(size.width, 6),
                child: LinearProgressIndicator(
                  minHeight: 5,
                  value: loadingPercentage.toDouble() / 100.0,
                  backgroundColor: kwhite25525525510,
                  color: kblue12915824210,
                ),
              )
            : null,
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
