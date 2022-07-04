import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final IconData? icon;
  final bool? issufixIcon;
  final double? topRight;
  final double? topLeft;
  final double? bottomLeft;
  final double? bottomRight;
  final double? size;
  final double? paddingLeft;
  final double? paddingRight;
  final double? paddingTop;
  final double? paddingBottom;
  final Color? color;
  final Function()? onPressed;
  final Function(String)? onChanged;
  final Color? prefixColor;
  final Color? sufixColor;

  CustomTextField(
      {required this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.obscureText = false,
      this.topRight,
      this.topLeft,
      this.bottomLeft,
      this.bottomRight,
      this.issufixIcon,
      this.onPressed,
      this.size,
      this.color,
      this.onChanged,
      this.paddingRight,
      this.paddingLeft,
      this.paddingTop,
      this.paddingBottom,
      this.prefixColor,
      this.sufixColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(topRight ?? 0.0),
          topLeft: Radius.circular(topLeft ?? 0.0),
          bottomLeft: Radius.circular(bottomLeft ?? 0.0),
          bottomRight: Radius.circular(bottomRight ?? 0.0)),
      // elevation: large! ? 6 : (medium! ? 4 : 2),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: obscureText!,
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: Theme.of(context).iconTheme.color,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
              bottom: paddingBottom ?? 0,
              top: paddingTop ?? 0,
              right: paddingRight ?? 0,
              left: paddingLeft ?? 0),
          /*      focusedBorder:  UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).iconTheme.color!),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius:BorderRadius.only(
          topRight: Radius.circular(topRight ?? 0.0),
            topLeft: Radius.circular(topLeft ?? 0.0),
            bottomLeft: Radius.circular(bottomLeft ?? 0.0),
            bottomRight: Radius.circular(bottomRight ?? 0.0)),
            borderSide: BorderSide(color: Colors.black),
          ),*/
          prefixIcon: Icon(icon,
              color: prefixColor ?? Theme.of(context).iconTheme.color,
              size: size ?? 21),
          suffixIcon: issufixIcon!
              ? IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.arrow_forward,
                    color: sufixColor ?? Theme.of(context).iconTheme.color,
                  ))
              : SizedBox(),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ),
    );
  }
}
