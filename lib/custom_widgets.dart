import 'package:flutter/material.dart';
import 'custom_functions.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.isMultiline,
    this.autoFocus,
    this.textStyle,
    this.isTextAlignCenter,
    required this.isUnderline,
    this.onChanged,
    this.validator,
    this.initialValue,
  });

  final String? initialValue;
  final String hintText;
  final TextStyle? textStyle;
  final bool? isMultiline;
  final bool? autoFocus;
  final bool? isTextAlignCenter;
  final bool isUnderline;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextFormField(
        initialValue: initialValue,
        textAlign: isTextAlignCenter == true ? TextAlign.center : TextAlign.start,
        autofocus: autoFocus == true,
        keyboardType: isMultiline == true ? TextInputType.multiline : null,
        maxLines: isMultiline == true ? null : 1,
        style: textStyle,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textStyle,
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: isUnderline
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: theme(context).secondary,
                  ),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme(context).secondary,
                  ),
                ),
          focusedBorder: isUnderline
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: theme(context).primary,
                  ),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: theme(context).primary,
                  ),
                ),
        ),
      ),
    );
  }
}

class CustomMargin extends StatelessWidget {
  const CustomMargin({super.key, this.height, this.width});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 100,
      height: height ?? 100,
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    required this.textColor,
    this.width,
    required this.isRoundedSquare,
  });

  final String label;
  final Color color;
  final Color textColor;
  final bool isRoundedSquare;
  final double? width;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          shape: isRoundedSquare
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
        ),
        child: Text(label),
      ),
    );
  }
}
