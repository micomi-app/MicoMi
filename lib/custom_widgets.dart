import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  )
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  )
              )
          ),
        )
    );
  }
}

class CustomPadding extends StatelessWidget {
  const CustomPadding({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: height,
    );
  }
}