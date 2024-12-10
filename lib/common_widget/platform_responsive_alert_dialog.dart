import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_livechat_app/common_widget/platform_responsive_widget.dart';

class PlatformResponsiveAlertDialog extends PlatformResponsiveWidget {
  final String title;
  final String content;
  final String buttonString;
  final String? cancelButtonString;

  PlatformResponsiveAlertDialog(
      {required this.title,
      required this.content,
      required this.buttonString,
      this.cancelButtonString});

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _alertDialogButton(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _alertDialogButton(context),
    );
  }

  List<Widget> _alertDialogButton(BuildContext context) {
    final allButtons = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonString != null) {
        allButtons.add(
          CupertinoDialogAction(
            child: Text(cancelButtonString!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }
      allButtons.add(
        CupertinoDialogAction(
          child: Text(buttonString),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButtonString != null) {
        allButtons.add(
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButtonString!),
          ),
        );
      }

      allButtons.add(
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(buttonString),
        ),
      );
    }

    return allButtons;
  }
}
