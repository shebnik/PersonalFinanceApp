import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/utils/app_assets.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/logger.dart';
import 'package:pfa_flutter/utils/utils.dart';

class AppWidgets {
  static Widget get loading => const Center(child: CircularProgressIndicator());

  static Widget onError(BuildContext context, dynamic error) {
    Logger.e('[Error] $error');
    return Center(
      child: Text(
        error.toString(),
      ),
    );
  }

  static void openSnackbar({
    required String message,
    Duration? duration,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    Get.snackbar(
      "",
      message,
      borderRadius: 4,
      titleText: const SizedBox(
        width: 0,
        height: 0,
      ),
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      snackStyle: SnackStyle.GROUNDED,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryGreen,
      colorText: Colors.black,
      duration: duration ?? const Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: onPressed ?? () => Get.back(),
        child: Text(
          buttonText ?? 'OK',
          style: const TextStyle(
            color: AppTheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static ElevatedButton elevatedButton(
    String text, {
    required VoidCallback onPressed,
    bool disabled = false,
  }) {
    return ElevatedButton(
      onPressed: disabled ? null : onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.all(16),
        ),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => disabled ? AppTheme.black(0.35) : AppTheme.primary,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  static TextButton textButton(
    String text, {
    required VoidCallback onPressed,
    bool disabled = false,
  }) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          color: disabled ? AppTheme.black(0.35) : AppTheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onPressed: disabled ? null : onPressed,
    );
  }

  static Widget textField({
    required TextEditingController controller,
    String hint = '',
    bool isPasswordType = false,
    bool isNumberType = false,
    bool showError = false,
    String? errorText,
    FocusNode? focusNode,
    Icon? prefixIcon,
  }) {
    var _obscureText = ValueNotifier<bool>(true);
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: ValueListenableBuilder(
        valueListenable: _obscureText,
        builder: (context, value, child) {
          return TextField(
            focusNode: focusNode,
            enableSuggestions: isPasswordType ? false : true,
            autocorrect: isPasswordType ? false : true,
            controller: controller,
            inputFormatters:
                Utils.getInputFormatters(isNumberType: isNumberType),
            obscureText: isPasswordType ? _obscureText.value : false,
            keyboardType: isNumberType ? TextInputType.number : null,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              hintText: hint,
              errorText: showError ? errorText : null,
              prefixIcon: prefixIcon,
              suffixIcon: isPasswordType
                  ? GestureDetector(
                      dragStartBehavior: DragStartBehavior.down,
                      onTap: () => _obscureText.value = !_obscureText.value,
                      child: Icon(
                        _obscureText.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        semanticLabel: _obscureText.value
                            ? AppStrings.showPassword
                            : AppStrings.hidePassword,
                      ),
                    )
                  : null,
            ),
            onChanged: (value) {
              if (isNumberType && value.contains(',')) {
                controller.text = value.replaceAll(",", ".");
                controller.value = controller.value.copyWith(
                  selection: TextSelection(
                    baseOffset: value.length,
                    extentOffset: value.length,
                  ),
                  composing: TextRange.empty,
                );
              }
            },
          );
        },
      ),
    );
  }

  static Widget get logo {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        children: [
          // Stack(
          //   alignment: AlignmentDirectional.center,
          //   children: [
          //     SvgPicture.asset(
          //       AppAssets.circle,
          //       height: 50,
          //       width: 50,
          //     ),
          //     Image.asset(
          //       AppAssets.logo,
          //       height: 25,
          //       width: 25,
          //     ),
          //   ],
          // ),
          Image.asset(
            AppAssets.logo,
            height: 50,
            width: 50,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              AppStrings.appNameCaps,
              style: TextStyle(
                color: AppTheme.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
