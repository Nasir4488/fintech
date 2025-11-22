// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:vrc_network/Provider/providers.dart';
// import 'package:vrc_network/Provider/theme_provider.dart';
// import 'package:vrc_network/Utils/extension.dart';
// import 'package:vrc_network/Utils/utils.dart';
// import 'package:vrc_network/assets.dart';
//
// class TransViewPage extends StatelessWidget {
//   final HistoryItem historyItem;
//   final String? funName;
//
//   const TransViewPage(this.historyItem, {this.funName, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Transaction Receipt",
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: textColor,
//                 fontWeight: FontWeight.w700,
//               ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Status",
//                 style: Theme.of(context)
//                     .textTheme
//                     .titleMedium
//                     ?.copyWith(fontWeight: FontWeight.w700, color: textColor),
//               ),
//               Text(historyItem.result?.toUpperCase() ?? "",
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w700,
//                       color: historyItem.result?.toLowerCase() == 'success'
//                           ? appGreenColor
//                           : Colors.red)),
//             ],
//           ).paddingOnly(bottom: 0),
//           if (funName != null)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Method",
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium
//                       ?.copyWith(fontWeight: FontWeight.w700),
//                 ),
//                 Text(funName ?? ""),
//               ],
//             ).paddingOnly(bottom: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Form",
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.w700,
//                           color: textColor,
//                         ),
//                   ),
//                   Text(formatWalletAddress(historyItem.from?.hash ?? ""),
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             color: Colors.blue,
//                             decoration: TextDecoration.underline,
//                             decorationColor: Colors.blue,
//                             decorationThickness: 2.5,
//                             decorationStyle: TextDecorationStyle.double,
//                           )).onTap(() async {
//                     final url = "${vrcUrl}address/${historyItem.from?.hash}";
//
//                     await launchUrl(Uri.parse(url));
//                   }),
//                 ],
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "To",
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.w700,
//                           color: textColor,
//                         ),
//                   ),
//                   Text(formatWalletAddress(historyItem.to?.hash ?? ""),
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             color: Colors.blue,
//                             decoration: TextDecoration.underline,
//                             decorationColor: Colors.blue,
//                             decorationThickness: 2.5,
//                             decorationStyle: TextDecorationStyle.double,
//                           )),
//                 ],
//               ).onTap(() async {
//                 final url = "${vrcUrl}address/${historyItem.to?.hash}";
//
//                 await launchUrl(Uri.parse(url));
//               }),
//             ],
//           ).paddingOnly(bottom: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Hash",
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.w700,
//                       color: textColor,
//                     ),
//               ),
//                Image.asset(ImageSrc.COPY,scale: 2,color: textColor,).onTap(() {
//                 walletProvider.copyToClipBoard(historyItem.hash ?? "");
//               }).paddingOnly(left: 10),
//               const Expanded(child: SizedBox()),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "View on VRC Scan",
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Colors.yellow,
//                         ),
//                   ),
//                   Column(
//                     children: [
//                       Text(
//                         formatWalletAddress(historyItem.hash ?? ""),
//                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                               color: Colors.blue,
//                               decoration: TextDecoration.underline,
//                               decorationColor: Colors.blue,
//                               decorationThickness: 2.5,
//                               decorationStyle: TextDecorationStyle.double,
//                             ),
//                       ),
//                     ],
//                   ).onTap(() async {
//                     final url = "${vrcUrl}tx/${historyItem.hash}";
//
//                     await launchUrl(Uri.parse(url));
//                   })
//                 ],
//               ),
//             ],
//           ).paddingOnly(bottom: 50).onTap(() {
//             walletProvider.copyToClipBoard(historyItem.hash ?? "");
//           }),
//           Text(
//             "Transaction",
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.w700,
//               color: textColor
//                 ),
//           ).paddingOnly(bottom: 10),
//           Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//               borderRadius: BorderRadius.circular(
//                 10,
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Nonce",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontWeight: FontWeight.w700,
//                           color: textColor
//
//
//                       ),
//                     ),
//                     Text(
//                       historyItem.nonce.toString(),
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleSmall
//                           ?.copyWith(fontWeight: FontWeight.w400,
//
//                           color: textColor
//
//                       ),
//                     ),
//                   ],
//                 ).paddingOnly(bottom: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Amount",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontWeight: FontWeight.w700,
//                           color: textColor
//
//
//                       ),
//                     ),
//                     Text(
//                       "${BigInt.parse(historyItem.value ?? "0").toEther().formatNumber()} ${AppCurrency.VRC}",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleSmall
//                           ?.copyWith(fontWeight: FontWeight.w400,
//                           color: textColor
//
//                       ),
//                     ),
//                   ],
//                 ).paddingOnly(bottom: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Gas Limit (Units)",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontWeight: FontWeight.w700,
//                           color: textColor
//                       ),
//                     ),
//                     Text(
//                       historyItem.fee?.value ?? "",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleSmall
//                           ?.copyWith(fontWeight: FontWeight.w400,
//                           color: textColor
//                       ),
//                     ),
//                   ],
//                 ).paddingOnly(bottom: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Gas Used (Units)",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontWeight: FontWeight.w700,
//                           color: textColor
//                       ),
//                     ),
//                     Text(
//                       historyItem.gasPrice ?? "",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleSmall
//                           ?.copyWith(fontWeight: FontWeight.w400,
//                           color: textColor
//                       ),
//                     ),
//                   ],
//                 ).paddingOnly(bottom: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Gas Price",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontWeight: FontWeight.w700,
//                           color: textColor
//                       ),
//                     ),
//                     Text(
//                       historyItem.gasUsed ?? "",
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleSmall
//                           ?.copyWith(fontWeight: FontWeight.w400,
//                           color: textColor
//                       ),
//                     ),
//                   ],
//                 ).paddingOnly(bottom: 20),
//               ],
//             ).paddingAll(10),
//           )
//         ],
//       ).paddingAll(20),
//     );
//   }
// }
//
// class HistoryItem {
// }
