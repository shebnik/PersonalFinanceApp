import 'package:flutter/material.dart';
import 'package:pfa_flutter/utils/app_assets.dart';
import 'package:pfa_flutter/utils/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image(
                  image: AssetImage(AppAssets.logo),
                  height: 120,
                  width: 120,
                ),
                SizedBox(height: 20),
                Text(
                  "WELCOME BACK!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Loading the good stuff...",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
