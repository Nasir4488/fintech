
import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  const ReusableTextField({
    Key? key,
    required this.title,
    required this.hint,
    this.isNumber,
    required this.controller,
    required this.formkey,
  }) : super(key: key);

  final String title, hint;
  final bool? isNumber;
  final TextEditingController controller;
  final Key formkey;

  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        width: 1,
        color: Colors.grey,
      ),
    );

    return Form(
      key: widget.formkey,
      child: TextFormField(
        cursorHeight: 20,
        cursorColor: Colors.grey,
        maxLines: 1,
        keyboardType: widget.isNumber == null
            ? TextInputType.text
            : TextInputType.number,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          labelText: widget.title,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
          border: outlineInputBorder,
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorder.copyWith(
            borderSide: const BorderSide(
              color: Colors.grey,

              width: 1,
            ),
          ),
          errorBorder: outlineInputBorder.copyWith(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: outlineInputBorder.copyWith(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 16.0,
          ),
        ),
        validator: (value) => value!.isEmpty ? "Cannot be empty" : null,
        controller: widget.controller,
      ),
    );
  }
}