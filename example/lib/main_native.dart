import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.blueAccent,
    ),
  );
  runApp(YoutubePlayerDemoNativeApp());
}

class YoutubePlayerDemoNativeApp extends StatefulWidget {  
  @override
  _YoutubePlayerDemoNativeAppState createState() => _YoutubePlayerDemoNativeAppState();
}

class _YoutubePlayerDemoNativeAppState extends State<YoutubePlayerDemoNativeApp>{
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube Player Flutter (for Native Player)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.blueAccent,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 20.0,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.blueAccent,
        ),
      ),
      home: MyNativeHome(),
    );
  }
}

class MyNativeHome extends StatefulWidget {
  @override
  _MyNativeHomeState createState() => _MyNativeHomeState();
}

class _MyNativeHomeState extends State<MyNativeHome> {
  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("InAppWebView")),
      // drawer: myDrawer(context: context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                  "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container()),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: InAppWebView(
                  initialUrl: "https://flutter.dev/",
                  initialHeaders: {},
                  initialOptions: InAppWebViewWidgetOptions(
                    iosInAppWebViewOptions: IosInAppWebViewOptions(
                      allowsInlineMediaPlayback: true,
                    ),
                    inAppWebViewOptions: InAppWebViewOptions(
                      debuggingEnabled: true,
                    ),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onLoadStop:
                      (InAppWebViewController controller, String url) async {
                    setState(() {
                      this.url = url;
                    });
                  },
                  onProgressChanged:
                      (InAppWebViewController controller, int progress) {
                    setState(() {
                      this.progress = progress / 100;
                    });
                  },
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (webView != null) {
                      webView.goBack();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (webView != null) {
                      webView.goForward();
                    }
                  },
                ),
                RaisedButton(
                  child: Icon(Icons.refresh),
                  onPressed: () {
                    if (webView != null) {
                      webView.reload();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
