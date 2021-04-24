import 'package:flutter/material.dart';
import 'package:flutter_test_connection/provider/app_state.dart';
import 'package:flutter_test_connection/routers/page_actions.dart';
import 'package:flutter_test_connection/routers/pages.dart';
import 'package:flutter_test_connection/screens/DetailsScreen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: ()
          {
            // appState.currentAction = PageAction(
            //     state: PageState.addWidget,
            //     widget: DetailsScreen(id:2),
            //     page: DetailsPageConfig);
            appState.currentAction = PageAction(state: PageState.addPage, page: LoginPageConfig);
          },

          child: Text('Go to Details'),
        ),
      ),
    );
  }
}
