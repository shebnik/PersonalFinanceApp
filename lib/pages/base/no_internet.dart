import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/widgets/loading_widget.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  final MainController mainController = Get.find();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      showSnackBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingWidget();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Please check your Internet connection.',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(days: 1),
        action: SnackBarAction(
          label: 'Retry',
          textColor: AppTheme.primary,
          onPressed: retry,
        ),
      ),
    );
  }

  Future<void> retry() async {
    bool isOnline =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;
    if (isOnline) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      mainController.isOnline = isOnline;
    } else {
      showSnackBar();
    }
  }
}
