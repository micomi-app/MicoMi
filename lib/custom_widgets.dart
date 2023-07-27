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
  });

  final String hintText;
  final TextStyle? textStyle;
  final bool? isMultiline;
  final bool? autoFocus;
  final bool? isTextAlignCenter;
  final bool isUnderline;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextField(
        textAlign:
            isTextAlignCenter == true ? TextAlign.center : TextAlign.start,
        autofocus: autoFocus == true,
        keyboardType: isMultiline == true ? TextInputType.multiline : null,
        maxLines: isMultiline == true ? null : 1,
        style: textStyle,
        onChanged: onChanged,
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
  const CustomMargin({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: height,
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
          backgroundColor: isPrimary ? Theme.of(context).primaryColor : null,
          foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
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
