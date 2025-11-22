// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:vrc_network/GlobalWidgets/loading.dart';
// import 'package:vrc_network/Provider/theme_provider.dart';
// import 'package:vrc_network/Utils/utils.dart';
//
// import 'package:youtube_shorts/youtube_shorts.dart';
//
// class ShortsByVideoUrlDisplay extends StatefulWidget {
//   const ShortsByVideoUrlDisplay({super.key});
//
//   @override
//   State<ShortsByVideoUrlDisplay> createState() => _ShortsByVideoStateUrlDisplay();
// }
//
// class _ShortsByVideoStateUrlDisplay extends State<ShortsByVideoUrlDisplay> {
//   late final ShortsController controller;
//   late Timer _timer;
//   late int _timerSeconds;
//
//   void initializeVideo() async {
//     _timerSeconds = 15;
//
//     controller = ShortsController(
//       youtubeVideoSourceController: VideosSourceController.fromUrlList(
//         videoIds: [
//           'https://www.youtube.com/shorts/avKmobAPwzA',
//           // 'https://www.youtube.com/shorts/avKmobAPwzA',
//         ],
//       ),
//     );
//
//     _startTimer();
//   }
//
//   void _startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_timerSeconds > 0) {
//           _timerSeconds--;
//         } else {
//           _timer.cancel();
//         }
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     initializeVideo();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return YoutubeShortsPage(
//       loadingWidget: const DataLoading(),
//       controller: controller,
//       onCurrentVideoPlayCallback: (
//         VideoData prevVideo,
//         int prevIndex,
//         int currentIndex,
//       ) {},
//       overlayWidgetBuilder: (
//         int index,
//         PageController pageController,
//         VideoController videoController,
//         Video videoData,
//         MuxedStreamInfo hostedVideoUrl,
//       ) {
//         controller.addListener(() {});
//
//         return Padding(
//           padding: const EdgeInsets.only(top: 100, left: 16),
//           child: _timerSeconds == 0
//               ? IconButton(
//                   onPressed: Get.back,
//                   icon: const Icon(
//                     Icons.cancel_outlined,
//                     color: Colors.grey,
//                   ),
//                 )
//               : Text(
//                   _timerSeconds.toString(),
//                   style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         color: appGreenColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ).paddingOnly(top: 20),
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     controller.removeListener(() {});
//     controller.dispose();
//     _timer.cancel();
//
//     super.dispose();
//   }
// }
