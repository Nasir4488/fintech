import 'package:fin_tech/GlobalWidgets/expended_button.dart';
import 'package:fin_tech/Pages/fee_list_view.dart';
import 'package:fin_tech/Pages/pay_fee_bottom_sheet.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class DuesView extends StatefulWidget {
  const DuesView({super.key});

  @override
  State<DuesView> createState() => _DuesViewState();
}

class _DuesViewState extends State<DuesView> {
  @override
  void initState() {
    studentFeeProvider.feeAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = authProviders.getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dues", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      bottomNavigationBar: ExpandedButton(
        label: "Pay Fee",
        onPress: () {
          payFeeBottomSheet();
        },
        filled: true,
      ).paddingSymmetric(horizontal: 20).paddingOnly(bottom: 20),
      body: Column(
        children: [
          ListTile(
            dense: true,
            leading: Text("Total Fee", style: Theme.of(context).textTheme.titleMedium),
            title: Text("${user?.totalFee} ${AppCurrency.ETH}",
                style: Theme.of(context).textTheme.titleMedium),
          ),
          ListTile(
            dense: true,
            leading: Text("Pending Fee", style: Theme.of(context).textTheme.titleMedium),
            title: Text("${user?.pendingFee} ${AppCurrency.ETH}",
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const Divider(),
          const Expanded(child: FeeListView())
        ],
      ),
    );
  }
}
