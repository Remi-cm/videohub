import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:videohub/core/utils/colors.dart';

import '../core/providers/theme_provider.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final bool? expand, enable, isLoading, isVisible;
  final bool isLite;
  final Color? color, textColor;
  final EdgeInsetsGeometry? padding;
  final Function()? action;
  const CustomTextButton({Key? key, required this.text, this.padding, this.isLoading = false, this.enable = true, this.isVisible, this.isLite = false, this.textColor, this.color, required this.action, this.expand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return isVisible == false ? Container() : SizedBox(
      width: expand == true ? double.infinity : null,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: !isLoading! ? TextButton(
          onPressed: enable == false ? null : action,
          child: Text(text, style: TextStyle(color: enable! ? (textColor ?? (themeProvider.isDark ? Colors.grey[800] : whiteColor)) : Colors.grey[700], fontSize: isLite ? 16 : null)),
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(enable! ? color ?? primaryColor : Colors.grey[400]),
            padding: isLite ? const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 10, vertical: 3)) : null,
          ),
        ) :
        const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CustomIconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool? expand, isLoading, isVisible;
  final bool isLite, enable;
  final Color? color, textColor;
  final EdgeInsetsGeometry? padding;
  final Function()? action;
  const CustomIconTextButton({Key? key, required this.text, this.expand, this.enable = true, this.isVisible, this.isLoading, this.isLite = false, this.color, this.textColor, this.padding, this.action, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = !enable ? Colors.grey[600]! : color ?? primaryColor;
    return isLoading != true ? (isVisible == false ? Container() : TextButton.icon(
      onPressed: !enable ? null : action, 
      icon: Icon(icon, color: buttonColor, size: 25,), 
      label: Text(text, style: TextStyle(color: buttonColor, fontSize: isLite ? 16 : 17),),
      style: ButtonStyle(
        padding: MaterialStatePropertyAll(isLite ? const EdgeInsets.symmetric(horizontal: 10, vertical: 3) : const EdgeInsets.all(10)),
        backgroundColor: MaterialStatePropertyAll(buttonColor.withOpacity(0.2))
      ),
    ))
    : CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(buttonColor),);
  }
}