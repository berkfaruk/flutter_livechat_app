// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget {
  final String buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final double? radius;
  final double? height;
  final Widget? buttonIcon;
  final VoidCallback onPressed;
  const SocialLogInButton({
    Key? key,
    required this.buttonText,
    this.buttonColor,
    this.textColor,
    this.radius,
    this.height,
    this.buttonIcon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (buttonIcon != null) ...[
            buttonIcon!,
            Text(
              buttonText,
              style: TextStyle(color: textColor),
            ),
            Opacity(opacity: 0, child: buttonIcon),
          ],
          if (buttonIcon == null) ...[
            Container(),
            Text(
              buttonText,
              style: TextStyle(color: textColor),
            ),
            Container(),
          ]
        ],
      ),
    );
  }
}

/*
buttonIcon != null ? buttonIcon! : Container(),
          Text(
            buttonText,
            style: TextStyle(color: textColor),
          ),
          buttonIcon != null ? Opacity(opacity: 0, child: buttonIcon) : Container(),

if (buttonIcon != null) buttonIcon!,
          Text(
            buttonText,
            style: TextStyle(color: textColor),
          ),
          if (buttonIcon != null) Opacity(opacity: 0, child: buttonIcon),

*/
