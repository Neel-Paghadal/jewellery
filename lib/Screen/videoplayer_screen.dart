// import 'package:chewie/chewie.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:jewellery_user/ConstFile/constColors.dart';
// import 'package:video_player/video_player.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
// import 'dart:typed_data';
//
//
//
// class ImageItem extends StatelessWidget {
//   final String url;
//
//   const ImageItem({Key? key, required this.url}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Image.network(
//       url,
//       height: 150,
//       width: 150,
//       fit: BoxFit.cover,
//     );
//   }
// }
//
// class VideoItem extends StatelessWidget {
//   final String url;
//
//   const VideoItem({Key? key, required this.url}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: FutureBuilder(
//         future: VideoThumbnail.thumbnailData(
//           video: url,
//           imageFormat: ImageFormat.JPEG,
//           quality: 10,
//         ),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//
//             return Stack(
//               alignment: Alignment.center,
//               children: [
//                 Image.memory(
//                   snapshot.data as Uint8List,
//                   fit: BoxFit.fill,
//                   filterQuality: FilterQuality.high,
//                 ),
//                 const Icon(
//                   CupertinoIcons.play_circle_fill,
//                   color: ConstColour.primaryColor,
//                   size: 35,
//                 )
//               ],
//             );
//
//           } else {
//
//             return const Center(child: CircularProgressIndicator(color: ConstColour.primaryColor,));
//
//           }
//         },
//       ),
//     );
//   }
// }
//
//
// class VideoPlayerDialog extends StatefulWidget {
//   final String url;
//
//   const VideoPlayerDialog({Key? key, required this.url}) : super(key: key);
//
//   @override
//   _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
// }
//
// class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
//   late VideoPlayerController _controller;
//   late ChewieController _chewieController;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url),
//         videoPlayerOptions: VideoPlayerOptions(
//           allowBackgroundPlayback: false,
//           mixWithOthers: true,));
//     setState(() {
//       _chewieController = ChewieController(
//         videoPlayerController: _controller,
//         allowFullScreen: true,
//         autoInitialize: true,
//         zoomAndPan: true,
//         autoPlay: true,
//         looping: true,
//         materialProgressColors: ChewieProgressColors(
//           playedColor: Colors.black,
//           handleColor: Colors.blue,
//           backgroundColor: Colors.grey,
//           bufferedColor: ConstColour.primaryColor,
//         ),
//         placeholder: const Center(
//           child: CircularProgressIndicator(color: ConstColour.primaryColor,),
//         ),
//       );
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topLeft,
//       children: [
//         _chewieController != null ? Chewie(
//           controller: _chewieController,
//         ) : const CircularProgressIndicator(color: ConstColour.primaryColor,),
//         IconButton(onPressed: () {
//           Get.back();
//         }, icon: Icon(Icons.arrow_back_outlined,size: 28,color: ConstColour.primaryColor,))
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }
// }























//new

import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:jewellery_user/Controller/order_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';



class ImageItem extends StatelessWidget {
  final String url;

  const ImageItem({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: 150,
      width: 150,
      fit: BoxFit.cover,
    );
  }
}

class VideoItem extends StatelessWidget {
  final String url;

  const VideoItem({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: VideoThumbnail.thumbnailData(
          video: url,
          imageFormat: ImageFormat.JPEG,
          quality: 10,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {

            return Stack(
              alignment: Alignment.center,
              children: [
                Image.memory(
                  snapshot.data as Uint8List,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                const Icon(
                  CupertinoIcons.play_circle_fill,
                  color: ConstColour.primaryColor,
                  size: 35,
                )
              ],
            );

          } else {

            return const Center(child: CircularProgressIndicator(color: ConstColour.primaryColor,));

          }
        },
      ),
    );
  }
}


class VideoItemLocal extends StatefulWidget {
  final File videoPath;

  const VideoItemLocal({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoItemLocalState createState() => _VideoItemLocalState();
}

class _VideoItemLocalState extends State<VideoItemLocal> {

  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath.toString()))
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _initialized
          ? Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
            child: Icon(
              _controller.value.isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_filled,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


class VideoPlayerDialog extends StatefulWidget {
  final String url;

  const VideoPlayerDialog({Key? key, required this.url}) : super(key: key);

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url),
        videoPlayerOptions: VideoPlayerOptions(
            allowBackgroundPlayback: false,
            mixWithOthers: true,));
    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        allowFullScreen: true,
        autoInitialize: true,
        zoomAndPan: true,
        autoPlay: true,
        looping: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.black,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: ConstColour.primaryColor,
        ),
        placeholder: const Center(
          child: CircularProgressIndicator(color: ConstColour.primaryColor,),
        ),
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        _chewieController != null ? Chewie(
          controller: _chewieController,
        ) : const CircularProgressIndicator(color: ConstColour.primaryColor,),
        IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back_outlined,size: 28,color: ConstColour.primaryColor,))
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}


class VideoPlayerDialogLocal extends StatefulWidget {
  final String filePath;

  const VideoPlayerDialogLocal({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPlayerDialogLocalState createState() => _VideoPlayerDialogLocalState();
}

class _VideoPlayerDialogLocalState extends State<VideoPlayerDialogLocal> {
  OrderController  orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
  orderController.chewieController;
    orderController.controller = VideoPlayerController.file(File(widget.filePath));
    orderController.chewieController = ChewieController(
      videoPlayerController: orderController.controller!,
      aspectRatio: orderController.chewieController?.aspectRatio,
      allowFullScreen: true,
      autoInitialize: true,
      zoomAndPan: true,
      autoPlay: true,
      looping: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.black,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: ConstColour.primaryColor,
      ),
      placeholder: const Center(
        child: CircularProgressIndicator(color: ConstColour.primaryColor,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        orderController.chewieController != null   ? Chewie(
          controller: orderController.chewieController!,
        ) : const CircularProgressIndicator(color: ConstColour.primaryColor,),
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_outlined,size: 28,color: ConstColour.primaryColor,)
        ),
      ],
    );
  }

  @override
  void dispose() {
    orderController.controller!.dispose();
    orderController.chewieController!.dispose();
    super.dispose();
  }
}





