// Copyright 2019 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../enums/player_state.dart';
import '../utils/youtube_player_controller.dart';

/// A widget to display play/pause button.
class LoadingWidget extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController controller;

  /// Defines placeholder widget to show when player is in buffering state.
  final Widget bufferIndicator;

  /// Modify the widget size.
  final double size;

  /// Color of indicator
  final Color color;

  /// Creates [LoadingWidget] widget.
  LoadingWidget({
    this.controller,
    this.bufferIndicator,
    this.size = 30.0,
    this.color,
  });

  @override
  _LoadingWidgetState createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  YoutubePlayerController _controller;
  double get _size => widget.size;
  Color get _color => widget.color;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = YoutubePlayerController.of(context);
    if (_controller == null) {
      assert(
        widget.controller != null,
        '\n\nNo controller could be found in the provided context.\n\n'
        'Try passing the controller explicitly.',
      );
      _controller = widget.controller;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.value.playerState == PlayerState.buffering) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          child: SpinKitRing(
            color: _color,
            size: _size > 0 ? _size : 30.0,
            lineWidth: 3.0,
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
