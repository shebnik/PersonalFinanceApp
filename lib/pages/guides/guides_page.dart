import 'package:flutter/material.dart';
import 'package:pfa_flutter/models/preferences.dart';
import 'package:pfa_flutter/services/shared_preferences_service.dart';

class GuidesPage extends StatefulWidget {
  static const routeName = '/guides';
  const GuidesPage({Key? key}) : super(key: key);

  @override
  _GuidesPageState createState() => _GuidesPageState();
}

class _GuidesPageState extends State<GuidesPage> {
  late Preferences preferences;

  @override
  void initState() {
    super.initState();
    preferences = SharedPreferencesService.getPreferences()!;
  }

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
