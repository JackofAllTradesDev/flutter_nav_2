import 'package:flutter/material.dart';
import 'package:flutter_test_connection/provider/app_state.dart';
import 'package:flutter_test_connection/provider/login_provider.dart';
import 'package:flutter_test_connection/routers/page_actions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return Consumer<LoginProvider>(
      builder: (context, value, __){
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                appState.currentAction = PageAction(state: PageState.pop);
              },
            ),
          ),
        );
      },

    );
  }
}
