// AppDrawer buttons that execute a provided function when tapped

import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  const DrawerButton({
    Key? key,
    required this.buttonTitle,
    required this.routeName,
    required this.leadingWidget,
    required this.onTap,
  }) : super(key: key);
  final String buttonTitle;
  final String routeName;
  final Widget leadingWidget;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onTap();
        },
        leading: leadingWidget,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            buttonTitle,
            textAlign: TextAlign.left,
          ),
        ));
  }
}
