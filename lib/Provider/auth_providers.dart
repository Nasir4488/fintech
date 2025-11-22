import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:fin_tech/GlobalWidgets/expended_button.dart';
import 'package:fin_tech/GlobalWidgets/input_field.dart';
import 'package:fin_tech/Models/user_model.dart';
import 'package:fin_tech/Pages/get_app_password_page.dart';
import 'package:fin_tech/Provider/theme_provider.dart';
import 'package:fin_tech/Services/storage_services.dart';
import 'package:fin_tech/Utils/utils.dart';
import 'package:fin_tech/utils/extension.dart';

class AuthProviders extends ChangeNotifier {
  void preventScreenshotOn() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!kDebugMode) await ScreenProtector.preventScreenshotOn();
    }
  }

  void preventScreenshotOff() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (!kDebugMode) await ScreenProtector.preventScreenshotOff();
    }
  }

  void handleAuth(AppLifecycleState state) {
    if (allowToLoginWithoutAuth()) return;

    if (AppStorage.box.hasData(AppStorage.WALLET_PASSWORD)) {
      if (state == AppLifecycleState.paused) {
        Navigator.of(Get.context!).push(
          MaterialPageRoute(
            builder: (context) {
              return const GetAppPasswordPage();
            },
            fullscreenDialog: true,
          ),
        );
      }
    }
  }

  bool allowToLoginWithoutAuth() {
    if (AppStorage.box.hasData(AppStorage.WALLET_PASSWORD)) {
      if (AppStorage.box.hasData(AppStorage.LAST_TIME_OF_AUTH) == false) return false;
      String dateTimeString = AppStorage.box.read(AppStorage.LAST_TIME_OF_AUTH);
      DateTime dateTime = DateTime.parse(dateTimeString);
      String current = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(DateTime.now());
      DateTime currentParsing = DateTime.parse(current);
      final difference = currentParsing.difference(dateTime).inMinutes;
      if (difference > 5) {
        return false;
      }
    }
    return true;
  }

  Future<bool>? authenticateUser() async {
    if (allowToLoginWithoutAuth()) return true;

    final LocalAuthentication auth = LocalAuthentication();
    final formKey = GlobalKey<FormState>();

    final list = await auth.getAvailableBiometrics();

    if (list.isEmpty || AppStorage.box.read(AppStorage.ENABLE_BIO) != true) {
      bool validate = false;
      final controller = TextEditingController();
      await Get.bottomSheet(
        SizedBox(
          height: Get.height,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.shield_moon_outlined, color: primaryColor, size: 50)
                      .toGradientMask()
                      .paddingOnly(top: 20),
                  Text(
                    "Please Enter Your Password to Authenticate",
                    style: Theme.of(Get.context!).textTheme.bodyLarge,
                  ).paddingOnly(top: 20),
                  Row(
                    children: [
                      Expanded(
                        child: AppFormField(
                          obscureText: true,
                          maxLine: 1,
                          controller: controller,
                          validator: (String? v) {
                            if (v!.isEmpty) {
                              return "Required";
                            } else if (AppStorage.box.read(AppStorage.WALLET_PASSWORD) !=
                                controller.text) {
                              return "Password Mismatch";
                            }
                            return null;
                          },
                        ).paddingSymmetric(horizontal: 20, vertical: 20),
                      ),
                    ],
                  ),
                  ExpandedButton(
                    onPress: () {
                      if (formKey.currentState!.validate()) {
                        validate = true;

                        saveLastLoginDateTime();

                        Get.back();
                      }
                    },
                    label: "Authenticate",
                    filled: true,
                    icon: const Icon(Icons.shield_moon_outlined, color: Colors.black),
                  ).paddingAll(20)
                ],
              ),
            ),
          ),
        ),
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(
              10,
            ),
            topLeft: Radius.circular(
              10,
            ),
          ),
        ),
        backgroundColor: Theme.of(Get.context!).cardColor,
        isScrollControlled: false,
        isDismissible: false,
      );
      return validate;
    }

    bool res = await auth.authenticate(
      localizedReason: 'Please Authenticate',
      options: const AuthenticationOptions(
        biometricOnly: true,
      ),
    );

    if (res) {
      saveLastLoginDateTime();
      return true;
    }
    return false;
  }

  void saveLastLoginDateTime() async {
    String dateTime = DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(DateTime.now());
    await AppStorage.box.write(AppStorage.LAST_TIME_OF_AUTH, dateTime);
  }

  Future<bool> removeDataFromLocal() async {
    try {
      await AppStorage.box.remove(AppStorage.DARK_MODE);
      await AppStorage.box.remove(AppStorage.WALLET_INTRO);
      await AppStorage.box.remove(AppStorage.WALLETS_DATA);
      await AppStorage.box.remove(AppStorage.WALLET_PASSWORD);
      await AppStorage.box.remove(AppStorage.ENABLE_BIO);
      await AppStorage.box.remove(AppStorage.LAST_TIME_OF_AUTH);
      await AppStorage.box.remove(AppStorage.RPC);
      await AppStorage.box.remove(AppStorage.INSTALL_DATE);
      await AppStorage.box.remove(AppStorage.APP_RATED);
      await AppStorage.box.remove(AppStorage.RATE_LATER);
      await AppStorage.box.erase();
      return true;
    } on Exception catch (e) {
      logger.e(e);
      return false;
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      return googleUser;
    } catch (error) {
      logger.i('Error signing in with Google: $error');
      showToast(error.toString());
      return null;
    }
  }

  Future<bool> loginWithGoogle() async {
    GoogleSignInAccount? accountDetail = await _signInWithGoogle();
    if (accountDetail == null) return false;
    UserModel user = UserModel(
      name: accountDetail.displayName,
      email: accountDetail.email,
      photoUrl: accountDetail.photoUrl,
      id: accountDetail.id,
    );
    final res = await checkAndRetrieveUserData(accountDetail.id);
    if (res == null) {
      final result = await _storeUserData(user);
      if (result) {
        AppStorage.box.write(AppStorage.USERDATA, user.toJson());
        return true;
      }
    }

    return false;
  }

  Future<UserModel?> checkAndRetrieveUserData(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        UserModel user = UserModel(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          photoUrl: data['photoUrl'],
          totalFee: data['totalFee'],
          pendingFee: data['pendingFee'],
        );

        logger.i('User exists and data retrieved successfully');
        AppStorage.box.write(AppStorage.USERDATA, user.toJson());

        return user;
      } else {
        logger.w('User with ID $userId does not exist');
        return null;
      }
    } catch (e) {
      logger.e('Error checking or retrieving user data: $e');
      return null;
    }
  }

  Future<bool> _storeUserData(UserModel user) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);
      await userRef.set({
        'name': user.name,
        'email': user.email,
        'photoUrl': user.photoUrl,
        'id': user.id,
        'totalFee': user.totalFee ?? "0.1",
        'pendingFee': user.pendingFee ?? "0.1",
      }, SetOptions(merge: true));

      logger.i('User data stored successfully');
      return true;
    } catch (e) {
      logger.e('Error storing user data: $e');
      return false;
    }
  }

  Future<UserModel?> fetchUserData() async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(getUser()?.id);

      final DocumentSnapshot userDoc = await userRef.get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        UserModel user = UserModel(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          photoUrl: data['photoUrl'],
          totalFee: data['totalFee'],
          pendingFee: data['pendingFee'],
        );

        logger.i('User data fetched successfully');
        AppStorage.box.write(AppStorage.USERDATA, user.toJson());

        return user;
      } else {
        logger.w('No user found ');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching user data: $e');
      return null;
    }
  }

  UserModel? getUser() {
    return userModelFromJson(json.encode(AppStorage.box.read(AppStorage.USERDATA)));
  }
}
