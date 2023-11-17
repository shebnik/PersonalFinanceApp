import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/pages/dashboard/dashboard.dart';
import 'package:pfa_flutter/widgets/loading_widget.dart';

import 'dashboard_loader_controller.dart';

class DashboardLoader extends StatelessWidget {
  static const routeName = '/dashboard';

  const DashboardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardLoaderController controller =
        Get.put(DashboardLoaderController());
    return Obx(() {
      if (controller.isInitialized.value) return const Dashboard();
      return const LoadingWidget();
    });
  }
}
