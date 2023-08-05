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
    required this.label,
    required this.onPressed,
    required this.isPrimary,
    this.width,
    required this.isRoundedSquare,
  });

  final String label;
  final bool isPrimary;
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
          backgroundColor: isPrimary
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.tertiary,
          foregroundColor: isPrimary ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onBackground,
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
