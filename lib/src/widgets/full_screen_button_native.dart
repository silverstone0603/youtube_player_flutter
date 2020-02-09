// Copyright 2019 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../utils/youtube_player_controller_native.dart';

/// A widget to display the full screen toggle button.
class FullScreenButtonNative extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerControllerNative controller;

  /// Defines color of the button.
  final Color color;

  /// Creates [FullScreenButtonNative] widget.
  FullScreenButtonNative({
    this.controller,
    this.color = Colors.white,
  });

  @override
  _FullScreenButtonNativeState createState() => _FullScreenButtonNativeState();
}

class _FullScreenButtonNativeState extends State<FullScreenButtonNative> {
  YoutubePlayerControllerNative _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = YoutubePlayerControllerNative.of(context);
    if (_controller == null) {
      assert(
        widget.controller != null,
        '\n\nNo controller could be found in the provided context.\n\n'
        'Try passing the controller explicitly.',
      );
      _controller = widget.controller;
    }
    _controller.removeListener(listener);
    _controller.addListener(listener);
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _controller.value.isFullScreen
            ? Icons.fullscreen_exit
            : Icons.fullscreen,
        color: widget.color,
      ),
      onPressed: () => _controller.toggleFullScreenMode(),
    );
  }
}
