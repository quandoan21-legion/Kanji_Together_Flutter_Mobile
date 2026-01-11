import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String placeholder;
  final String? title;

  final TextInputType type;
  final bool isPassword;

  final Color textColor;
  final Color titleColor;
  final Color backgroundColor;
  final Color borderColor;

  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;

  final int maxLines;
  final bool enabled;

  final double fontSize;
  final double titleFontSize;

  // 👉 FONT STYLE
  final String? fontFamily;
  final String? titleFontFamily;
  final FontWeight fontWeight;
  final FontWeight titleFontWeight;

  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.placeholder,
    this.title,

    this.type = TextInputType.text,
    this.isPassword = false,

    this.textColor = Colors.black,
    this.titleColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,

    this.borderRadius = 8,
    this.padding = const EdgeInsets.all(12),
    this.margin = const EdgeInsets.all(8),

    this.maxLines = 1,
    this.enabled = true,

    this.fontSize = 14,
    this.titleFontSize = 12,

    this.fontFamily,
    this.titleFontFamily,
    this.fontWeight = FontWeight.normal,
    this.titleFontWeight = FontWeight.w500,

    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: titleFontSize,
                color: titleColor,
                fontFamily: titleFontFamily,
                fontWeight: titleFontWeight,
              ),
            ),
            const SizedBox(height: 6),
          ],
          TextField(
            controller: controller,
            keyboardType: type,
            obscureText: isPassword,
            maxLines: maxLines,
            enabled: enabled,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: placeholder,
              filled: true,
              fillColor: backgroundColor,
              contentPadding: padding,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}