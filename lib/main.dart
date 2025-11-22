import 'package:fin_tech/Provider/student_fee_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '/Provider/WalletProviders/funds_provider.dart';
import '/firebase_options.dart';
import '/Provider/ContractProviders/contract_providers.dart';
import '/Provider/auth_providers.dart';
import '/Utils/Locale/languages.dart';
import '/Utils/utils.dart';
import '/Provider/WalletProviders/wallet_provider.dart';
import '/Provider/theme_provider.dart';
import 'Models/transcation.dart';
import 'Models/transctionAdopter.dart';
import 'splash_page.dart';


void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GetStorage.init();

  // Initialize Hive properly

  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<UserTransaction>('transactions');
  await Hive.openBox('incomeBox');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider()),
        ChangeNotifierProvider.value(value: AuthProviders()),
        ChangeNotifierProvider.value(value: ContractProvider()),
        ChangeNotifierProvider.value(value: WalletProvider()),
        ChangeNotifierProvider.value(value: FundTransferProvider()),
        ChangeNotifierProvider.value(value: StudentFeeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth =FirebaseAuth.instance;
    return GetMaterialApp(
      initialBinding: MyBinding(),
      translations: Messages(),
      locale: Locale(Messages.getLanguageCode(), Messages.getLanguageCountryCode()),
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).getAppTheme(context),
      home: const SplashPage(),
    );
  }
}

class MyBinding extends Bindings {
  @override
  void dependencies() {}
}
