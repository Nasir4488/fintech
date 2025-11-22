// import 'package:flutter/material.dart';
// import 'package:vrc_network/Provider/theme_provider.dart';
//
// class PrimaryGradientText extends StatelessWidget {
//   final String? text;
//   final TextStyle? style;
//   final TextAlign? textAlign;
//
//   const PrimaryGradientText(this.text, {this.style, this.textAlign, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       blendMode: BlendMode.srcIn,
//       shaderCallback: (bounds) => linearGradient.createShader(
//         Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//       ),
//       child: Text(
//         text ?? "text",
//         style: style,
//         textAlign: textAlign,
//       ),
//     );
//   }
// }
//
// class PrimaryGradientTextSPain extends StatelessWidget {
//   final String? text;
//   final TextStyle? style;
//   final TextAlign? textAlign;
//   final List<TextSpan>? children;
//
//   const PrimaryGradientTextSPain(this.text, {this.style, this.textAlign, this.children, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       blendMode: BlendMode.srcIn,
//       shaderCallback: (bounds) => linearGradient.createShader(
//         Rect.fromLTWH(0, 0, bounds.width, bounds.height),
//       ),
//       child: RichText(
//         text: TextSpan(text: text, children: children),
//       ),
//     );
//   }
// }
