import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfa_flutter/models/linked_account.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/utils/app_strings.dart';
import 'package:pfa_flutter/utils/utils.dart';
import 'package:pfa_flutter/widgets/app_widgets.dart';
import 'accounts_page_controller.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  late AccountsPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AccountsPageController());
  }

  @override
  Widget build(BuildContext context) {
    return accountsWidget();
  }

  Widget accountsWidget() {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: controller.isLoading,
        builder: (context, bool loading, child) {
          return Column(
            children: [
              const SizedBox(height: 30),
              InkWell(
                child: Container(
                  width: double.infinity,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadow,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_outlined,
                        color: AppTheme.primary,
                      ),
                      Text(
                        AppStrings.linkAccount,
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: !loading ? controller.openLinkClick : null,
              ),
              const SizedBox(height: 10),
              const Text(
                AppStrings.linkAccountsSecurely,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 40),
              loading ? AppWidgets.loading : linkedAccountsList(),
            ],
          );
        },
      ),
    );
  }

  Widget linkedAccountsList() {
    return ValueListenableBuilder<List<LinkedAccount>>(
      valueListenable: controller.accountList,
      builder: (context, value, child) => value.isEmpty
          ? Container()
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.linkedAcocunts,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                accountList(value),
              ],
            ),
    );
  }

  Widget accountList(List<LinkedAccount> list) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final account = list[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(Utils.getAccountInfo(account)),
          trailing: ValueListenableBuilder<bool>(
            valueListenable: controller.isLoading,
            builder: (context, _disabled, child) => Wrap(
              children: [
                AppWidgets.textButton(
                  AppStrings.unlink,
                  onPressed: () => controller.onUnlink(account),
                  disabled: _disabled,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
