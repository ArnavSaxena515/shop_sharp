import 'package:flutter/material.dart';
import 'package:shop_sharp/screens/product_detail_screen.dart';

class CustomRoute extends MaterialPageRoute {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
    //return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}

class CustomRouteBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }
    if (route.settings.name == ProductDetail.routeName) {
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
