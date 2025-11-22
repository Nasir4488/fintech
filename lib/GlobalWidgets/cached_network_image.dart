// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// class AppCachedNetworkImage extends StatelessWidget {
//   final String url;
//
//   const AppCachedNetworkImage(this.url, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       imageUrl: url,
//       imageBuilder: (context, imageProvider) => Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: imageProvider,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//       placeholder: (context, url) => Shimmer.fromColors(
//         baseColor: Colors.grey.withOpacity(.5),
//         highlightColor: Colors.white10,
//         child: Container(color: Colors.grey.withOpacity(.5),
//         ),
//       ),
//       errorWidget: (context, url, error) => const Icon(
//         Icons.error,
//         color: Colors.red,
//       ),
//     );
//   }
// }
