import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/main_controller.dart';
import 'package:pfa_flutter/pages/auth/create_account/create_account.dart';
import 'package:pfa_flutter/pages/auth/login/login.dart';
import 'package:pfa_flutter/pages/auth/reset_password/reset_password.dart';
import 'package:pfa_flutter/pages/base/no_internet.dart';
import 'package:pfa_flutter/pages/dashboard_loader/dashboard_loader.dart';
import 'package:pfa_flutter/pages/start/start.dart';
import 'package:pfa_flutter/services/firebase/auth_service.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferencesService.sharedPreferences =
      await SharedPreferences.getInstance();

  initRoutePath = await AuthService.defineInitRoutePath();

  runApp(const MyApp());
}

var initRoutePath = '/';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.put(MainController());
    controller.prepare();

    return GetMaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(
        primarySwatch: AppTheme.primarySwatch,
        fontFamily: 'Montserrat',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
              fontFamily: 'Montserrat',
            ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initRoutePath,
      getPages: [
        GetPage(
          name: Start.routeName,
          page: () => const Start(),
        ),
        GetPage(
          name: CreateAccount.routeName,
          page: () => const CreateAccount(),
        ),
        GetPage(
          name: Login.routeName,
          page: () => const Login(),
        ),
        GetPage(
          name: ResetPassword.routeName,
          page: () => const ResetPassword(),
        ),
        GetPage(
          name: DashboardLoader.routeName,
          page: () => const DashboardLoader(),
        ),
      ],
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const ScrollBehavior(),
          child: Stack(
            children: [
              if (child != null) child,
              Obx(() => Visibility(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        child: AppWidgets.loading,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                    visible: controller.isLoading,
                  )),
              Obx(() => Visibility(
                    child: NoInternet(key: UniqueKey()),
                    visible: !controller.isOnline,
                  )),
            ],
          ),
        );
      },
    );
  }
}
