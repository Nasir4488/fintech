import 'package:fin_tech/Provider/student_fee_providers.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:fin_tech/Provider/ContractProviders/contract_providers.dart';
import 'package:fin_tech/Provider/auth_providers.dart';
import '/Provider/WalletProviders/wallet_provider.dart';
import '/Provider/theme_provider.dart';



ThemeProvider themeProvider = Provider.of<ThemeProvider>(Get.context!, listen: false);
AuthProviders authProviders = Provider.of<AuthProviders>(Get.context!, listen: false);
WalletProvider walletProvider = Provider.of<WalletProvider>(Get.context!, listen: false);
ContractProvider contractProvider = Provider.of<ContractProvider>(Get.context!, listen: false);
StudentFeeProvider studentFeeProvider = Provider.of<StudentFeeProvider>(Get.context!, listen: false);

