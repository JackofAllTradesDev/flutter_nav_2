
import 'package:flutter/material.dart';
import 'package:flutter_test_connection/routers/pages.dart';


class ShoppingParser extends RouteInformationParser<PageConfiguration> {
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isEmpty) {
      return MainPageConfig;
    }

    final path = '/' + uri.pathSegments[0];

    switch (path) {
      case MainPath:
        return MainPageConfig;
      case LoginPath:
        return LoginPageConfig;
      case DetailsPath:
        return DetailsPageConfig;

      default:
        return MainPageConfig;
    }
  }

  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Main:
        return const RouteInformation(location: MainPath);
      case Pages.Login:
        return const RouteInformation(location: LoginPath);

      case Pages.Details:
        return const RouteInformation(location: DetailsPath);

      default: return const RouteInformation(location: MainPath);

    }
  }
}