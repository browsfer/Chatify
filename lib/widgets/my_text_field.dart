import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final bool? obscureText;
  final TextEditingController? textController;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final Widget? prefixIcon;
  final Color? prefixIconColor;

  const MyTextField({
    super.key,
    required this.labelText,
    this.obscureText,
    this.textController,
    this.validator,
    this.prefixIcon,
    this.prefixIconColor,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      validator: validator,
      controller: textController,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        prefixIconColor:
            prefixIconColor ?? Theme.of(context).colorScheme.primary,
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        filled: true,
        fillColor: Color(0xFFC2BAA6),
      ),
    );
  }
}
