import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test_connection/provider/app_state.dart';
import 'package:flutter_test_connection/routers/back_dispatcher.dart';
import 'package:flutter_test_connection/routers/pages.dart';
import 'package:flutter_test_connection/routers/parser.dart';
import 'package:flutter_test_connection/routers/router_delegate.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final appState = AppState();
  ShoppingRouterDelegate delegate;
  final parser = ShoppingParser();
  ShoppingBackButtonDispatcher backButtonDispatcher;
  StreamSubscription _linkSubscription;

  _MyHomePageState() {
    delegate = ShoppingRouterDelegate(appState);
    delegate.setNewRoutePath(MainPageConfig);
    backButtonDispatcher = ShoppingBackButtonDispatcher(delegate);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    if (_linkSubscription != null) _linkSubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Attach a listener to the Uri links stream
    _linkSubscription = getUriLinksStream().listen((Uri uri) {
      print(uri);
      if (!mounted) return;
      setState(() {
        delegate.parseRoute(uri);
      });
    }, onError: (Object err) {
      print('Got error $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider<AppState>(
      create: (context) => appState,
      child: MaterialApp.router(
        title: 'Navigation App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        backButtonDispatcher: backButtonDispatcher,
        routerDelegate: delegate,
        routeInformationParser: parser,
      ),
    );
  }
}
