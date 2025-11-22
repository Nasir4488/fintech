import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fin_tech/Provider/theme_provider.dart';

class AppFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? iconData;
  final int? maxLine;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final TextInputType? inputType;
  final bool? obscureText;
  final bool? readOnly;
  final Widget? suffix;
  final double? radius;
  final ValueChanged<String>? onChange;
  final VoidCallback? onTap;
  final double? padding;




  const AppFormField({
    super.key,
    this.onChange,
    this.iconData,
    this.suffix,
    this.obscureText,
    this.inputType,
    this.controller,
    this.hintText,
    this.maxLine,
    this.validator,
    this.readOnly,
    this.radius,
    this.onTap,
    this.padding,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = Get.height * .015;

    return TextFormField(
      controller: controller,
      maxLines: maxLine,
      validator: validator,
      keyboardType: inputType,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      onChanged: onChange,
      onTap: onTap,
      maxLength: maxLength,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon:suffix ,
        hintText: hintText,
        contentPadding: EdgeInsets.all(padding??screenHeight),
        hintStyle:
            Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey,

            fontWeight: FontWeight.w400),
        border: OutlineInputBorder(
            borderSide:  BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(radius ?? 10.0)),
        focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(radius ?? 10.0)),
        enabledBorder: OutlineInputBorder(
            borderSide:  BorderSide(color:primaryColor),
            borderRadius: BorderRadius.circular(radius ?? 10.0)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(radius ?? 10.0)),
      ),
    );
  }
}
