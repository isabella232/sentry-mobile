import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sentry_mobile/utils/sentry_colors.dart';

import '../../redux/state/app_state.dart';
import '../../screens/project_picker/project_picker.dart';
import 'settings_header.dart';
import 'settings_view_model.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {


  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SettingsViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => SettingsViewModel.fromStore(store),
    );
  }

  Widget _content(SettingsViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsHeader('Projects'),
              ),
              ListTile(
                title: Text(
                  'Bookmarked Projects',
                  style: Theme.of(context).textTheme.bodyText1.apply(
                    color: SentryColors.revolver
                  ),
                ),
                subtitle: Text(
                    viewModel.bookmarkedProjects,
                    style: Theme.of(context).textTheme.subtitle1.apply(
                        color: SentryColors.mamba
                    )
                ),
                leading: Icon(
                  Icons.star,
                  color: SentryColors.lightningYellow,
                ),
                onTap: () =>
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProjectPicker()
                      ),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SettingsHeader('Account'),
              ),
              ListTile(
                title: Text(
                  "Sign Out",
                  style: Theme.of(context).textTheme.bodyText1.apply(
                      color: SentryColors.revolver
                  ),
                ),
                leading: Icon(
                  Icons.exit_to_app,
                  color: SentryColors.royalBlue,
                ),
                onTap: () => Navigator.pop(context, true),
              )
            ],
          ),
        ),
      ),
    );
  }
}