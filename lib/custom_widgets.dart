import 'package:flutter/material.dart';

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
        textAlign:
            isTextAlignCenter == true ? TextAlign.center : TextAlign.start,
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
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
          focusedBorder: isUnderline
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
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
    this.child,
    this.label,
    required this.onPressed,
    this.onLongPress,
    required this.isPrimary,
    this.width,
    required this.isRoundedSquare,
  });

  final Widget? child;
  final String? label;
  final bool isPrimary;
  final bool isRoundedSquare;
  final double? width;
  final void Function()? onPressed;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? Theme.of(context).primaryColor
              : Color.lerp(Theme.of(context).colorScheme.onBackground,
                  Theme.of(context).colorScheme.background, 0.9)!,
          foregroundColor: isPrimary
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.onBackground,
          shape: isRoundedSquare
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              : null,
        ),
        child: label == null ? child : Text(label!),
      ),
    );
  }
}
