import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

//
// class MultimediaList extends StatelessWidget {
//   final List<String> multimediaItems = [
//     'http://208.64.33.118:8558/Files/Test/6802ddb5-4a5f-4251-9600-a34734a46741_scaled_1000098522.jpg', // Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/6779676c-531e-4b54-a65d-c19838c9a6c7_1000097887.mp4', // Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/523a7f61-627a-4843-bf48-ca6589cacc25_1000097881.mp4', // Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/94eb711f-3f8b-46bd-ac5e-d8fbf158dc03_scaled_1000098518.jpg',
//     'http://208.64.33.118:8558/Files/Test/37baa9a4-83e2-4e09-94f7-d59d2fa655e1_1000097883.mp4', // Replace with actual URL// Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/f1ade3ce-4dcb-4246-9ce5-dcc609bd0c2e_scaled_1000095609.jpg',
//     // Add more multimedia URLs as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: multimediaItems.length,
//       itemBuilder: (context, index) {
//         final item = multimediaItems[index];
//         if (item.endsWith('.mp4')) {
//           return VideoItem(url: item);
//         } else {
//           return ImageItem(url: item);
//         }
//       },
//     );
//   }
// }

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
          maxWidth: 150,
          quality: 25,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Stack(
              alignment:  Alignment.center,
              children: [
                Image.memory(snapshot.data as Uint8List,fit: BoxFit.fill,),
                const Icon(Icons.play_arrow_outlined,color: ConstColour.primaryColor,size: 40,)
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

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
//   late Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(widget.url,);
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.play();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return  AspectRatio(
//           aspectRatio: _controller.value.aspectRatio,
//           child: FutureBuilder(
//             future: _initializeVideoPlayerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return VideoPlayer(_controller);
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           ),
//         );
//       }
//     );
//   }
// }


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
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url),videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: false));
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      allowFullScreen: true,
      autoInitialize: true,
      allowedScreenSleep: false,
      fullScreenByDefault: false,
      aspectRatio: _controller.value.aspectRatio,
      cupertinoProgressColors: ChewieProgressColors(bufferedColor: Colors.green),
      autoPlay: true,
      looping: true,
      // Other customization options can be added here
    );
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}











//
// class MultimediaList extends StatelessWidget {
//   final List<String> multimediaItems = [
//     'http://208.64.33.118:8558/Files/Test/6802ddb5-4a5f-4251-9600-a34734a46741_scaled_1000098522.jpg', // Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/6779676c-531e-4b54-a65d-c19838c9a6c7_1000097887.mp4', // Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/523a7f61-627a-4843-bf48-ca6589cacc25_1000097881.mp4', // Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/94eb711f-3f8b-46bd-ac5e-d8fbf158dc03_scaled_1000098518.jpg',
//     'http://208.64.33.118:8558/Files/Test/37baa9a4-83e2-4e09-94f7-d59d2fa655e1_1000097883.mp4', // Replace with actual URL// Replace with actual URL
//     'http://208.64.33.118:8558/Files/Test/f1ade3ce-4dcb-4246-9ce5-dcc609bd0c2e_scaled_1000095609.jpg', // Replace with actual URL
//     // Add more multimedia URLs as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: multimediaItems.length,
//       itemBuilder: (context, index) {
//         final item = multimediaItems[index];
//         if (item.endsWith('.mp4')) {
//           return VideoItem(url: item);
//         } else {
//           return Image.network(multimediaItems[index].toString());
//         }
//       },
//     );
//   }
// }
//
// class ImageItem extends StatelessWidget {
//   final String url;
//
//   const ImageItem({Key? key, required this.url}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       // child: CachedNetworkImage(
//       //   imageUrl: url,
//       //   placeholder: (context, url) => Center(child: CircularProgressIndicator()),
//       //   errorWidget: (context, url, error) => Icon(Icons.error),
//       //   height: 150,
//       //   width: 150,
//       //   fit: BoxFit.cover,
//       // ),
//       child: Image.network(url),
//     );
//   }
// }
//
// class VideoItem extends StatefulWidget {
//   final String url;
//
//   const VideoItem({Key? key, required this.url}) : super(key: key);
//
//   @override
//   _VideoItemState createState() => _VideoItemState();
// }
//
// class _VideoItemState extends State<VideoItem> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//
//   @override
//   void initState() {
//
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
//     _initializeVideoPlayerFuture = _controller.initialize();
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       child: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             );
//           } else {
//
//             return const Center(child: CircularProgressIndicator());
//
//           }
//         },
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
