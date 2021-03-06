import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../redux/state/app_state.dart';
import '../../screens/scanner/scanner_screen.dart';
import '../../utils/sentry_colors.dart';
import 'connect_view_model.dart';

class ConnectScreen extends StatefulWidget {
  @override
  _ConnectScreenState createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {

  var _loading = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConnectViewModel>(
      builder: (_, viewModel) => _content(viewModel),
      converter: (store) => ConnectViewModel.fromStore(store),
    );
  }

  Widget _content(ConnectViewModel viewModel) {
    return Container(
        margin: EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            if (_loading)
              Expanded(
                child: Center(child: CircularProgressIndicator())
              )
            else
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Ok, lets go!',
                      style: Theme.of(context).textTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Navigate to "Mobile app" in settings...',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 4,
                            color: Colors.black.withAlpha(50),
                            offset: Offset(2, 2),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: Image.asset(
                          'assets/user-menu.png',
                          height: 192,
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    ButtonTheme(
                      minWidth: 144,
                      child: RaisedButton.icon(
                          label: Text('Scan Token'),
                          icon: Icon(
                              Icons.qr_code,
                              color: Colors.white
                          ),
                          textColor: Colors.white,
                          color: SentryColors.rum,
                          onPressed: () async {
                            final encodedToken = await _presentScannerScreen();
                            setState(() {
                              _loading = encodedToken != null;
                            });
                            try {
                              await viewModel.onTokenEncoded(encodedToken);
                            } catch (_) {
                              setState(() {
                                _loading = false;
                              });
                              _handleTokenFailure();
                            }
                          }
                      ),
                    ),
                    SizedBox(height: 22),
                    Text('OR'),
                    SizedBox(height: 12),
                    FlatButton(
                        textColor: SentryColors.royalBlue,
                        child: Text('Open "Mobile app" in settings'),
                        onPressed: _openAccountSettings
                    ),
                    ButtonTheme(
                      minWidth: 144,
                      child: RaisedButton.icon(
                        label: Text('Paste Token'),
                        icon: Icon(
                            Icons.content_paste_rounded,
                            color: Colors.white
                        ),
                        textColor: Colors.white,
                        color: SentryColors.rum,
                        onPressed: () async {
                          final enteredToken = await _showDialog();
                          setState(() {
                            _loading = enteredToken != null;
                          });
                          try {
                            await viewModel.onToken(enteredToken);
                          } catch (_) {
                            setState(() {
                              _loading = false;
                            });
                            _handleTokenFailure();
                          }
                        },
                      ),
                    ),

                  ],
                )
              )
          ],
        )
    );
  }

  Future<void> _openAccountSettings() async {
    const url = 'https://sentry.io/settings/account/api/mobile-app/';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Future<String> _presentScannerScreen() async {
    return await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => ScannerScreen()
      ),
    ) as String;
  }

  Future<String> _showDialog() async {
    final textEditingController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text('Paste Token'),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Paste your token here'
                  )
                ),
              ),
              IconButton(
                  icon: Icon(Icons.content_paste_rounded),
                  color: SentryColors.rum,
                  onPressed: () async {
                    textEditingController.text = await FlutterClipboard.paste();
                  }
              )
            ]
          ),
          actions: <Widget>[
            FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                }),
            FlatButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(textEditingController.text);
                })
          ],
        );
      },
    );
  }

  void _handleTokenFailure() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Error',
              style: Theme.of(context).textTheme.headline1
          ),
          content: Text(
              'Something went wrong. Please try again.',
              style: Theme.of(context).textTheme.bodyText1
          ),
          actions: [
            FlatButton(
                key: Key('ok'),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok')),
          ],
        );
      }
    );
  }
}