import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/models/mentor.dart';
import 'package:pfa_flutter/models/payment/payment_info.dart';
import 'package:pfa_flutter/models/payment/stripe_info.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/models/user.dart';
import 'package:pfa_flutter/pages/auth/create_account/create_account.dart';
import 'package:pfa_flutter/pages/auth/login/login.dart';
import 'package:pfa_flutter/pages/auth/reset_password/reset_password.dart';
import 'package:pfa_flutter/pages/dashboard_loader/dashboard_loader.dart';
import 'package:pfa_flutter/pages/start/start.dart';
import 'package:pfa_flutter/services/firebase/firestore_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class AuthService {
  static final instance = AuthService._();

  AuthService._();

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static Future<bool> isSignedIn() async =>
      await auth.authStateChanges().first != null;
  static String getUserId() => auth.currentUser!.uid;
  static final MainController mainController = Get.find<MainController>();

  static Future<bool> createAccount(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final uid = userCredential.user!.uid;
      await addUserRecordToFirestore(name, email, uid);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Logger.i('The password provided is too weak.');
        AppWidgets.openSnackbar(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Logger.i('The account already exists for that email.');
        AppWidgets.openSnackbar(
            message: 'The account already exists for that email.');
      } else {
        Logger.e('createAccount error:', e);
        AppWidgets.openSnackbar(message: e.message ?? AppStrings.error);
      }
      return false;
    } catch (e) {
      Logger.e('createAccount error: ', e);
      AppWidgets.openSnackbar(message: AppStrings.error);
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final uid = userCredential.user!.uid;
      await getUser(uid);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Logger.i('No user found for that email.');
        AppWidgets.openSnackbar(message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Logger.i('Wrong password provided for that user.');
        AppWidgets.openSnackbar(
            message: 'Wrong password provided for that user.');
      } else {
        Logger.e('createAccount error:', e);
        AppWidgets.openSnackbar(message: e.message ?? AppStrings.loginError);
      }
      return false;
    } catch (e) {
      Logger.e('signIn error', e);
      return false;
    }
  }

  static Future<bool> addUserRecordToFirestore(
    String name,
    String email,
    String uid,
  ) async {
    DateTime today = DateTime.now();
    DateTime trialEndDate = today.add(const Duration(days: 7));

    AppUser user = AppUser(
      userId: uid,
      trialEndDate: trialEndDate,
      createdDate: today,
      email: email,
      name: name,
      stripeInfo: StripeInfo(
        status: 'inactive',
        stripeCustomerId: null,
      ),
      inAppPaymentInfo: InAppPaymentInfo(
        gateway: "",
        subscriptionId: "",
      ),
      linkedAccounts: [],
    );

    bool result = await FirestoreService(uid).setUser(user);
    if (result) {
      SharedPreferencesService.setUser(user);
    }
    await FirestoreService(uid).setPreferences();
    return result;
  }

  static Future<void> getUser(String uid) async {
    AppUser? user = await FirestoreService(uid).getUser();
    if (user != null) {
      SharedPreferencesService.setUser(user);
    }
    Mentor? mentor = await FirestoreService(uid).getMentor();
    if (mentor != null) {
      SharedPreferencesService.setMentor(mentor);
    }
    Preferences? preferences = await FirestoreService(uid).getPreferences();
    if (preferences != null) {
      SharedPreferencesService.setPreferences(preferences);
    }
  }

  static void listenAuthState() {
    auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        Logger.i('[AuthState listener] User is currently signed out!');
        await SharedPreferencesService.clear();
        if (![
          Start.routeName,
          CreateAccount.routeName,
          Login.routeName,
          ResetPassword.routeName
        ].contains(Get.currentRoute)) {
          Get.offAllNamed(Start.routeName,
              predicate: (Route<dynamic> route) => false);
        }
      } else {
        Logger.i('[AuthState listener] User ${user.email} is signed in!');
      }
    });
  }

  static Future<String> defineInitRoutePath() async {
    if (await isSignedIn()) {
      Logger.i(
          '[defineInitRoutePath] User ${auth.currentUser?.email} is signed in!');
      return DashboardLoader.routeName;
    } else {
      Logger.i('[defineInitRoutePath] User is signed out!');
      return Start.routeName;
    }
  }

  static Future<void> resetPassword(email) {
    return auth.sendPasswordResetEmail(email: email);
  }

  static Future<void> logOut() async {
    mainController.cancelFirestoreListeners();
    await FirebaseAuth.instance.signOut();
    try {
      await FirebaseFirestore.instance.clearPersistence();
    } catch (e) {
      Logger.e('[LogOut] clearPersistence error', e);
    }
  }
}
