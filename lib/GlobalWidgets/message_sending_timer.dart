// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:vrc_network/Provider/providers.dart';
// import 'package:vrc_network/Provider/theme_provider.dart';
// import 'package:vrc_network/Services/storage_services.dart';
//
// class MessageSendingTimer extends StatefulWidget {
//   const MessageSendingTimer({super.key});
//
//   @override
//   State<MessageSendingTimer> createState() => _MessageSendingTimerState();
// }
//
// class _MessageSendingTimerState extends State<MessageSendingTimer> {
//   late DateTime endTime;
//
//   @override
//   void initState() {
//     super.initState();
//     String storedTimestamp =
//         AppStorage.box.read(AppStorage.LAST_TIME_OF_MESSAGE) ?? DateTime.now().toIso8601String();
//     DateTime parsedTime = DateTime.parse(storedTimestamp);
//     endTime = parsedTime.add(Duration(minutes: chatProviders.messageDelay)); // Adding 10 minutes
//     startTimer();
//   }
//
//   void startTimer() {
//     Duration remainingTime = endTime.difference(DateTime.now());
//
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           remainingTime = endTime.difference(DateTime.now());
//         });
//         if (remainingTime.isNegative || remainingTime.inSeconds == 0) {
//           timer.cancel();
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String formattedTime = DateFormat('mm:ss').format(
//       DateTime.fromMillisecondsSinceEpoch(
//         endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch,
//       ),
//     );
//
//     return Column(
//       children: [
//         Text(
//           "Remaining Time to next message",
//           style: Theme.of(context).textTheme.titleSmall?.copyWith(),
//         ),
//         Text(
//           formattedTime,
//           style: Theme.of(context).textTheme.titleSmall?.copyWith(color: textColor),
//         ),
//       ],
//     );
//   }
// }
