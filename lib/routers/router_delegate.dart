import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_connection/provider/app_state.dart';
import 'package:flutter_test_connection/provider/login_provider.dart';
import 'package:flutter_test_connection/routers/back_dispatcher.dart';
import 'package:flutter_test_connection/routers/page_actions.dart';
import 'package:flutter_test_connection/routers/pages.dart';
import 'package:flutter_test_connection/screens/DetailsScreen.dart';
import 'package:flutter_test_connection/screens/LoginScreen.dart';
import 'package:flutter_test_connection/screens/MainScreen.dart';
import 'package:provider/provider.dart';

class ShoppingRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<PageConfiguration> {
  final List<Page> _pages = [];
  ShoppingBackButtonDispatcher backButtonDispatcher;

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppState appState;

  ShoppingRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

  bool _onPopPage(Route<dynamic> route, result) {
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(MaterialPage page) {
    if (page != null) {
      _pages.remove(page);
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last);
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(Widget child, PageConfiguration pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfiguration pageConfig) {

    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;
    if (shouldAddPage) {
      switch (pageConfig.uiPage) {
        case Pages.Main:
          _addPageData(MainScreen(), MainPageConfig);
          break;
        case Pages.Login:
          _addPageData(MultiProvider(
            providers: [
              ChangeNotifierProvider<LoginProvider>(
                create: (context) => LoginProvider(),
              ),
            ],
              child: LoginScreen()), LoginPageConfig);
          break;
        case Pages.Details:
          _addPageData(DetailsScreen(), DetailsPageConfig);
          break;
        // case Pages.Details:
        //   if (pageConfig.currentPageAction != null) {
        //     _addPageData(pageConfig.currentPageAction.widget, pageConfig);
        //   }
        //   break;
        default:
          break;
      }
    }
  }

  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  void replaceAll(PageConfiguration newRoute) {
    print(newRoute.uiPage);
    setNewRoutePath(newRoute);
  }

  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    print(configuration);
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  void _setPageAction(PageAction action) {
    switch (action.page.uiPage) {
      case Pages.Main:
        MainPageConfig.currentPageAction = action;
        break;
      case Pages.Login:
        LoginPageConfig.currentPageAction = action;
        break;
      case Pages.Details:
        DetailsPageConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  List<Page> buildPages() {

      switch (appState.currentAction.state) {
        case PageState.none:
          break;
        case PageState.addPage:
          _setPageAction(appState.currentAction);
          addPage(appState.currentAction.page);
          break;
        case PageState.pop:
          pop();
          break;
        case PageState.replace:
          _setPageAction(appState.currentAction);
          replace(appState.currentAction.page);
          break;
        case PageState.replaceAll:
          _setPageAction(appState.currentAction);
          replaceAll(appState.currentAction.page);
          break;
        case PageState.addWidget:
          _setPageAction(appState.currentAction);
          pushWidget(appState.currentAction.widget, appState.currentAction.page);
          break;
        case PageState.addAll:
          addAll(appState.currentAction.pages);
          break;
      }

    appState.resetCurrentAction();
    return List.of(_pages);
  }


  void parseRoute(Uri uri) {
    print("Uri $uri");
    // if (uri.pathSegments.isEmpty) {
    //   setNewRoutePath(SplashPageConfig);
    //   return;
    // }
    //
    // //Handle navapp://deeplinks/details/#
    // if (uri.pathSegments.length == 2) {
    //   if (uri.pathSegments[0] == 'details') {
    //     pushWidget(Details(int.parse(uri.pathSegments[1])), DetailsPageConfig);
    //   }
    // } else
    //   if (uri.pathSegments.length == 1) {
    //   final path = uri.pathSegments[0];
    //   switch (path) {
    //     case 'splash':
    //       replaceAll(SplashPageConfig);
    //       break;
    //     case 'login':
    //       replaceAll(LoginPageConfig);
    //       break;
    //     case 'createAccount':
    //       setPath([
    //         _createPage(Login(), LoginPageConfig),
    //         _createPage(CreateAccount(), CreateAccountPageConfig)
    //       ]);
    //       break;
    //     case 'listItems':
    //       replaceAll(ListItemsPageConfig);
    //       break;
    //     case 'cart':
    //       setPath([
    //         _createPage(ListItems(), ListItemsPageConfig),
    //         _createPage(Cart(), CartPageConfig)
    //       ]);
    //       break;
    //     case 'checkout':
    //       setPath([
    //         _createPage(ListItems(), ListItemsPageConfig),
    //         _createPage(Checkout(), CheckoutPageConfig)
    //       ]);
    //       break;
    //     case 'settings':
    //       setPath([
    //         _createPage(ListItems(), ListItemsPageConfig),
    //         _createPage(Settings(), SettingsPageConfig)
    //       ]);
    //       break;
    //   }
    // }
  }
}
