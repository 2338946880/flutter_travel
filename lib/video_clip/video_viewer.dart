import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'clipper.dart';

class VideoViewer extends StatefulWidget {
  final Clipper clipper;

  final Color borderColor;

  final double borderWidth;

  final EdgeInsets padding;

  const VideoViewer({
    Key? key,
    required this.clipper,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.padding = const EdgeInsets.all(0.0),
  }) : super(key: key);

  @override
  _VideoViewerState createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  VideoPlayerController? get videoPlayerController =>
      widget.clipper.videoPlayerController;

  @override
  void initState() {
    widget.clipper.eventStream.listen((event) {
      if (event == ClipperEvent.initialized) {
        //The video has been initialized, now we can load stuff
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _controller = videoPlayerController;
    return _controller == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: _controller.value.isInitialized
                    ? Container(
                        foregroundDecoration: BoxDecoration(
                          border: Border.all(
                            width: widget.borderWidth,
                            color: widget.borderColor,
                          ),
                        ),
                        child: VideoPlayer(_controller),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    widget.clipper.dispose();
    super.dispose();
  }
}
