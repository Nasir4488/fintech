import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';

class WalletTransHistory extends StatefulWidget {
  const WalletTransHistory({super.key});

  @override
  State<WalletTransHistory> createState() => _WalletTransHistoryState();
}

class _WalletTransHistoryState extends State<WalletTransHistory> {
 late String dropdownValue;
  List<String> dropdownList = <String>['All', 'Deposit', 'Withdraw'];

  @override
  void initState() {
    dropdownValue=dropdownList.first;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Transactions",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: dropdownValue,
                iconEnabledColor: primaryColor,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w400,
                    ),
                items: dropdownList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  dropdownValue = v ?? 'All';
                  setState(() {});
                },
              ),
            )
          ],
        ).paddingOnly(top: 20),
        // Consumer<HistoryProvider>(
        //   builder: (BuildContext context, value, Widget? child) {
        //     return value.transactionsList.isNotEmpty
        //         ? Column(
        //             children: [
        //               // if (dropdownValue == dropdownList.first)
        //               //   TransHistoryTile(value.transactionsList),
        //               // if (dropdownValue == dropdownList[1])
        //               //   TransHistoryTile(value.depositList,
        //               //       functionName: 'Deposit', color: Colors.red),
        //               // if (dropdownValue == dropdownList.last)
        //               //   TransHistoryTile(
        //               //     value.withdrawList,
        //               //     functionName: 'Reward Withdraw',
        //               //     color: Colors.green,
        //               //   ),
        //               // SizedBox(
        //               //   height: Get.height * .4,
        //               // )
        //             ],
        //           )
        //         : SizedBox(height: Get.height * .4);
        //   },
        // )
      ],
    );
  }
}
