import 'package:flutter/material.dart';
import '/Provider/providers.dart';

class TransHistoryTile extends StatefulWidget {
  final String? functionName;
  final Color? color;

  const TransHistoryTile( {this.functionName, this.color, super.key});

  @override
  State<TransHistoryTile> createState() => _TransHistoryTileState();
}

class _TransHistoryTileState extends State<TransHistoryTile> with SingleTickerProviderStateMixin {

  @override
  void initState() {

    super.initState();
  }

  Future<void> getData() async {
    await walletProvider.getBalance();

    return;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      // itemCount: widget.historyItem.length,
      itemBuilder: (BuildContext context, int index) {
        // final data = widget.historyItem[index];

        return const SizedBox();

        // return GestureDetector(
        //   onTap: () {
        //     Get.to(() => TransViewPage(data, funName: widget.functionName));
        //   },
        //   child: Container(
        //           decoration: BoxDecoration(
        //               border: Border.all(color: primaryColor),
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               if (widget.functionName == null)
        //                 Container(
        //                         decoration: BoxDecoration(
        //                             color: themeProvider.isDarkMode ? Colors.black : Colors.white,
        //                             shape: BoxShape.circle),
        //                         child: Image.asset(
        //                           send ? ImageSrc.RECEIVE_FUNDS : ImageSrc.SEND_FUNDS,
        //                           scale: 2,
        //                         ).paddingAll(10))
        //                     .paddingOnly(right: 10),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   widget.functionName == null
        //                       ? Text(
        //                           send ? "VRC Received" : "Sent VRC",
        //                           style: Theme.of(context).textTheme.titleSmall?.copyWith(
        //                               color: send ? Colors.green : Colors.red,
        //                               fontWeight: FontWeight.w700),
        //                         )
        //                       : Text(
        //                           "${widget.functionName}",
        //                           style: Theme.of(context).textTheme.titleSmall?.copyWith(
        //                                 color: widget.color,
        //                               ),
        //                         ),
        //                   Text(
        //                     status.capitalize ?? "",
        //                     style: Theme.of(context).textTheme.titleSmall?.copyWith(
        //                         fontWeight: FontWeight.w700,
        //                         color: status == "Success" ? null : Colors.redAccent),
        //                   ),
        //                 ],
        //               ),
        //               const Expanded(child: SizedBox()),
        //               Column(
        //                 crossAxisAlignment: CrossAxisAlignment.end,
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   if (widget.functionName != "Reward Withdraw")
        //                     Text(
        //                       BigInt.parse(data.value ?? "0").toEther().formatNumber(),
        //                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
        //                             fontWeight: FontWeight.w400,
        //                             color: textColor,
        //                           ),
        //                     ),
        //                   if (widget.functionName == "Reward Withdraw")
        //                     Text(
        //                       BigInt.parse(data.decodedInput?.parameters.first.value ?? "0")
        //                           .toEther()
        //                           .formatNumber(),
        //                       style: Theme.of(context)
        //                           .textTheme
        //                           .titleMedium
        //                           ?.copyWith(fontWeight: FontWeight.w400, color: textColor),
        //                     ),
        //                   Text(
        //                     data.timestamp!.toFormattedString(),
        //                     style: Theme.of(context)
        //                         .textTheme
        //                         .titleSmall
        //                         ?.copyWith(fontWeight: FontWeight.w400, color: textColor),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ).paddingSymmetric(horizontal: 5, vertical: 5))
        //       .paddingOnly( bottom: 5),
        // );
      },
    );
  }
}
