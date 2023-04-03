import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isPasswordField;
  final Function(String value)? onTextChanged;
  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.isPasswordField = false,
    this.onTextChanged,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool isActive = false;
  bool obscureText = true;
  bool isObscureText() {
    if (!widget.isPasswordField) return false;
    if (!obscureText) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isObscureText(),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 16),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isActive ? Colors.green : Colors.black,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.none,
          ),
        ),
        filled: true,
        contentPadding: EdgeInsets.all(16),
        suffixIcon: widget.isPasswordField
            ? GestureDetector(
                onTap: () {
                  obscureText = !obscureText;
                  setState(() {});
                },
                child: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              )
            : null,
      ),
      controller: widget.controller,
      cursorColor: Colors.green,
      onTap: () {
        isActive = true;
        setState(() {});
      },
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      onChanged: (value) {
        widget.onTextChanged?.call(value);
      },
    );
  }
}
