import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:pfa_flutter/utils/payment/payment_services.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';

class SubscribeDialogController extends GetxController {
  RxInt selectedType = 0.obs;
  bool force = false;

  void subscribe() async {
    if (PaymentService.instance.isConnected) {
      List<IAPItem>? products = await PaymentService.instance.products;
      PaymentService.instance.buyProduct(products![selectedType.value]);
      Get.back();
    } else {
      AppWidgets.openSnackbar(
        message: "Not able to connect to store. Please try again.",
      );
    }
  }
}
