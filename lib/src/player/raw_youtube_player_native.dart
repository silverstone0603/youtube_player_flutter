// Copyright 2019 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../enums/player_state.dart';
import '../utils/youtube_meta_data.dart';
import '../utils/youtube_player_controller_native.dart';

/// A raw youtube player widget which interacts with the underlying webview inorder to play YouTube videos.
///
/// Use [YoutubePlayer] instead.
class RawYoutubePlayer extends StatefulWidget {
  /// Sets [Key] as an identification to underlying web view associated to the player.
  final Key key;

  /// {@macro youtube_player_flutter.onEnded}
  final void Function(YoutubeMetaData metaData) onEnded;

  /// Creates a [RawYoutubePlayer] widget.
  RawYoutubePlayer({
    this.key,
    this.onEnded,
  });

  @override
  _RawYoutubePlayerState createState() => _RawYoutubePlayerState();
}

class _RawYoutubePlayerState extends State<RawYoutubePlayer> with WidgetsBindingObserver {
  final Completer<InAppWebViewController> _inAppWebViewController = Completer<InAppWebViewController>();
  YoutubePlayerControllerNative controller;
  PlayerState _cachedPlayerState;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _inAppWebViewController.future.then((inAppWebViewController){
      
      inAppWebViewController.addJavaScriptHandler(handlerName: "Ready", callback: (callback){
        _isPlayerReady = true;
      });

      inAppWebViewController.addJavaScriptHandler(handlerName: "StateChange", callback: (callback){
        //TODO: 핸들러 코드로 변환 해야함

        // switch (callback.message) {
        //   case '-1':
        //     controller.updateValue(
        //       controller.value.copyWith(
        //         playerState: PlayerState.unStarted,
        //         isLoaded: true,
        //       ),
        //     );
        //     break;
        //   case '0':
        //     if (widget.onEnded != null) {
        //       widget.onEnded(controller.metadata);
        //     }
        //     controller.updateValue(
        //       controller.value.copyWith(
        //         playerState: PlayerState.ended,
        //       ),
        //     );
        //     break;
        //   case '1':
        //     controller.updateValue(
        //       controller.value.copyWith(
        //         playerState: PlayerState.playing,
        //         isPlaying: true,
        //         hasPlayed: true,
        //         errorCode: 0,
        //       ),
        //     );
        //     break;
        //   case '2':
        //     controller.updateValue(
        //       controller.value.copyWith(
        //         playerState: PlayerState.paused,
        //         isPlaying: false,
        //       ),
        //     );
        //     break;
        //   case '3':
        //     controller.updateValue(
        //       controller.value.copyWith(
        //         playerState: PlayerState.buffering,
        //       ),
        //     );
        //     break;
        //   case '5':
        //     controller.updateValue(
        //       controller.value.copyWith(
        //         playerState: PlayerState.cued,
        //       ),
        //     );
        //     break;
        //   default:
        //     throw Exception("Invalid player state obtained.");
        // }
      });

      inAppWebViewController.addJavaScriptHandler(handlerName: "PlaybackQualityChange", callback: (callback){
        //TODO: 핸들러 코드로 변환 해야함

        // controller.updateValue(
        //   controller.value.copyWith(
        //     playbackQuality: message.message,
        //   ),
        // );
      });

      inAppWebViewController.addJavaScriptHandler(handlerName: "PlaybackRateChange", callback: (callback){
        //TODO: 핸들러 코드로 변환 해야함

        // controller.updateValue(
        //   controller.value.copyWith(
        //     playbackRate: double.tryParse(message.message) ?? 1.0,
        //   ),
        // );
      });

      inAppWebViewController.addJavaScriptHandler(handlerName: "Errors", callback: (callback){
        //TODO: 핸들러 코드로 변환 해야함

        // controller.updateValue(
        //   controller.value
        //       .copyWith(errorCode: int.tryParse(message.message) ?? 0),
        // );
      });

      inAppWebViewController.addJavaScriptHandler(handlerName: "VideoData", callback: (callback){
        //TODO: 핸들러 코드로 변환 해야함

        // controller.updateValue(
        //   controller.value.copyWith(
        //     metaData: YoutubeMetaData.fromRawData(message.message),
        //   ),
        // );
      });

      inAppWebViewController.addJavaScriptHandler(handlerName: "CurrentTime", callback: (callback){
        //TODO: 핸들러 코드로 변환 해야함

        // var position = (double.tryParse(message.message) ?? 0) * 1000;
        // controller.updateValue(
        //   controller.value.copyWith(
        //     position: Duration(milliseconds: position.floor()),
        //   ),
        // );
      });

      inAppWebViewController.addJavaScriptHandler(handlerName: "LoadedFraction", callback: (callback){
        //TODO: 핸들러 코드로 변환 해야함

        // controller.updateValue(
        //   controller.value.copyWith(
        //     buffered: double.tryParse(message.message) ?? 0,
        //   ),
        // );
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_cachedPlayerState != null &&
            _cachedPlayerState == PlayerState.playing) {
          controller?.play();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        _cachedPlayerState = controller.value.playerState;
        controller?.pause();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    controller = YoutubePlayerControllerNative.of(context);
    return IgnorePointer(
      ignoring: true,
      child: InAppWebView(
        initialUrl: player,
        initialHeaders: {},
        initialOptions: InAppWebViewWidgetOptions(
          iosInAppWebViewOptions: IosInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
          inAppWebViewOptions: InAppWebViewOptions(
            clearCache: true,
            debuggingEnabled: false,
            javaScriptEnabled: true,
          ),
        ),
        onWebViewCreated: (InAppWebViewController webViewController) {
          _inAppWebViewController.complete(webViewController);
          _inAppWebViewController.future.then(
            (webViewController) {
              controller.updateValue(
                controller.value
                    .copyWith(inAppWebViewController: webViewController),
              );
            },
          );
        },
        onLoadStop: (InAppWebViewController webViewController, String url){
          if (_isPlayerReady) {
            controller.updateValue(
              controller.value.copyWith(isReady: true),
            );
          }
        },
      ),
    );
  }

  String get player {
    var _player = '''
    <!DOCTYPE html>
    <html>
    <head>
        <style>
            html,
            body {
                margin: 0;
                padding: 0;
                background-color: #000000;
                overflow: hidden;
                position: fixed;
    ''';
    if (!Platform.isIOS && controller.flags.forceHideAnnotation) {
      _player += '''
                height: 1000%;
                width: 1000%;
                transform: scale(0.1);
                transform-origin: left top;
      ''';
    } else {
      _player += '''
                height: 100%;
                width: 100%;
      ''';
    }
    _player += '''
            }
        </style>
        <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
    </head>
    <body>
        <div id="player"></div>
        <script>
            var tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            var player;
            var timerId;

        </script>
    </body>
    </html>
    ''';
    return 'data:text/html;base64,${base64Encode(const Utf8Encoder().convert(_player))}';
  }

  String boolean({@required bool value}) => value ? "'1'" : "'0'";
}