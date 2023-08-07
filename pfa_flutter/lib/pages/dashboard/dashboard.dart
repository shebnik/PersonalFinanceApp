import 'package:flutter/material.dart';
import 'package:pfa_flutter/pages/accounts/accounts_page.dart';
import 'package:pfa_flutter/pages/dashboard/dashboard_top_info.dart';
import 'package:pfa_flutter/pages/guides/guides_page.dart';
import 'package:pfa_flutter/pages/home/home_page.dart';
import 'package:pfa_flutter/pages/reports/reports_page.dart';
import 'package:pfa_flutter/pages/settings/settings_page.dart';
import 'package:pfa_flutter/services/transaction_service.dart';
import 'package:pfa_flutter/utils/app_theme.dart';
import 'package:pfa_flutter/utils/app_strings.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/home';

  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class TabItem {
  String title;
  Icon icon;

  TabItem({
    required this.title,
    required this.icon,
  });
}

final List<TabItem> _tabBar = [
  TabItem(title: AppStrings.home, icon: const Icon(Icons.home_outlined)),
  TabItem(title: AppStrings.accounts, icon: const Icon(Icons.savings_outlined)),
  TabItem(title: AppStrings.reports, icon: const Icon(Icons.insights_outlined)),
  TabItem(title: AppStrings.guides, icon: const Icon(Icons.lightbulb_outline)),
  TabItem(
      title: AppStrings.settings, icon: const Icon(Icons.settings_outlined)),
];

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: _tabBar.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        currentTabIndex = tabController.index;
      });
    });

    TransactionService.fetchTodaysTransactions();
  }

  Widget tabBarChild(Widget child, String title) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DashboardTopInfo(pageTitle: title),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: TabBarView(
          // physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            tabBarChild(
              const HomePage(key: Key(AppStrings.home)),
              AppStrings.home,
            ),
            tabBarChild(
              const AccountsPage(key: Key(AppStrings.accounts)),
              AppStrings.accounts,
            ),
            tabBarChild(
              const ReportsPage(key: Key(AppStrings.reports)),
              AppStrings.reports,
            ),
            tabBarChild(
              const GuidesPage(key: Key(AppStrings.guides)),
              AppStrings.guides,
            ),
            tabBarChild(
              const SettingsPage(key: Key(AppStrings.settings)),
              AppStrings.settings,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            tabController.index = index;
            currentTabIndex = index;
          });
        },
        currentIndex: currentTabIndex,
        selectedItemColor: AppTheme.primaryGreen,
        unselectedItemColor: AppTheme.primary,
        type: BottomNavigationBarType.fixed,
        items: [
          for (final item in _tabBar)
            BottomNavigationBarItem(
              label: item.title,
              icon: item.icon,
              tooltip: item.title,
            )
        ],
      ),
    );
  }
}
