import 'package:fin_tech/GlobalWidgets/expended_button.dart';
import 'package:fin_tech/Pages/pay_fee_bottom_sheet.dart';
import 'package:fin_tech/Provider/providers.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:fin_tech/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Pages/Wallet/vrc_wallet.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authProviders.getUser();

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(user?.photoUrl ??
                'https://s3.eu-ce'
                    'ntral-1.amazonaws.com/uploads.mangoweb.'
                    'org/shared-prod/visegradfund.org/uploads/2021/08/placeholder-male.jpg'),
          ),
          ListTile(
            dense: true,
            leading: Text("Name", style: Theme.of(context).textTheme.titleMedium),
            title: Text(user?.name ?? "", style: Theme.of(context).textTheme.titleMedium),
          ),
          ListTile(
            dense: true,
            leading: Text("Email", style: Theme.of(context).textTheme.titleMedium),
            title: Text(user?.email ?? "", style: Theme.of(context).textTheme.titleMedium),
          ),


        ],
      ),
    );
  }
}
