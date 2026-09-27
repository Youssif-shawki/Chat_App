import 'package:flutter/material.dart';


class CustomeTextFormField extends StatelessWidget {
  const CustomeTextFormField({
    required this.onChange,
    super.key,
    required this.labelText,
    required this.secure,
  });

  final String labelText;
  final bool secure;
  final Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'Please Enter Input';
        }
      },
      onChanged: onChange,
      style: TextStyle(color: Colors.white),

      obscureText: secure,

      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 20,
        ),

        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(width: 1.2, color: Colors.white),
        ),

        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(width: 1.8, color: Colors.white),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(width: 1.8, color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(width: 1.8, color: Colors.redAccent),
        ),

        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
