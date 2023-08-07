import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pfa_flutter/utils/app_constants.dart';
import 'package:pfa_flutter/utils/logger.dart';

// ignore: must_be_immutable
class LinkAccountWebView extends StatelessWidget {
  static const routeName = '/linkAccount';

  final Function(List<dynamic>) onInit;
  final Function(List<dynamic>) onSuccess;
  final Function(List<dynamic>) onExit;
  final Function(List<dynamic>) onFailure;

  LinkAccountWebView({
    Key? key,
    required this.onInit,
    required this.onSuccess,
    required this.onExit,
    required this.onFailure,
  }) : super(key: key);

  late InAppWebViewController? webViewController;

  final InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      supportZoom: false,
      horizontalScrollBarEnabled: false,
      transparentBackground: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InAppWebView(
        initialOptions: options,
        initialUrlRequest: URLRequest(
          url: Uri.parse(AppConstants.tellerConnectURL),
        ),
        onWebViewCreated: (controller) {
          Logger.i('WebviewCreated');
          webViewController = controller;
          controller.addJavaScriptHandler(
            handlerName: 'onInit',
            callback: onInit,
          );
          controller.addJavaScriptHandler(
            handlerName: 'onSuccess',
            callback: onSuccess,
          );
          controller.addJavaScriptHandler(
            handlerName: 'onExit',
            callback: onExit,
          );
          controller.addJavaScriptHandler(
            handlerName: 'onFailure',
            callback: onFailure,
          );
        },
        shouldOverrideUrlLoading: (controller, navigationAction) {
          var uri = navigationAction.request.url!;
          if (uri.toString() != AppConstants.tellerConnectURL) {
            Logger.i('shouldOverrideUrlLoading uri: ${uri.toString()}');
            return Future.value(NavigationActionPolicy.CANCEL);
          }
          return Future.value(NavigationActionPolicy.ALLOW);
        },
        onLoadStart: (controller, url) {
          Logger.i(url.toString());
        },
        onLoadError: (controller, url, code, message) {
          Logger.i('Error loading $url with message $message');
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT,
          );
        },
        onConsoleMessage: (controller, consoleMessage) {
          Logger.i('[InAppWebView] ${consoleMessage.toString()}');
        },
      ),
    );
  }
}
