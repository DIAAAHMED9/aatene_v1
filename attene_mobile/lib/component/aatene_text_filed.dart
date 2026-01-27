import '../general_index.dart';
import '../utils/responsive/index.dart';
import 'package:flutter/material.dart';

class TextFiledAatene extends StatelessWidget {
  const TextFiledAatene({
    super.key,
    required this.isRTL,
    required this.hintText,
    this.errorText,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.textInputType,
    this.controller,
    this.heightTextFiled,
    this.fillColor,
    this.maxLines,
    this.minLines,
    required this.textInputAction,
    this.onSubmitted,
    this.enabled,
    this.readOnly,
    this.onTap,
    this.autofocus,
    this.focusNode,
    this.validator,
    this.autovalidateMode,
    this.initialValue,
    this.style,
    this.hintStyle,
    this.labelText,
    this.floatingLabelBehavior,
    this.filled,
  });

  final bool isRTL;
  final bool? filled;
  final String hintText;
  final String? errorText;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool? obscureText;
  final double? radios = 50;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final double? heightTextFiled;
  final Color? fillColor;
  final int? maxLines;
  final int? minLines;
  final TextInputAction textInputAction;
  final bool? enabled;
  final bool? readOnly;
  final VoidCallback? onTap;
  final bool? autofocus;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;
  final String? initialValue;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final String? labelText;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: textInputType,
          obscureText: obscureText ?? false,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          maxLines: maxLines ?? 1,
          minLines: minLines,
          textInputAction: textInputAction,
          enabled: enabled ?? true,
          readOnly: readOnly ?? false,
          onTap: onTap,
          autofocus: autofocus ?? false,
          focusNode: focusNode,
          validator: validator,
          autovalidateMode: autovalidateMode,
          style:
              style ??
              TextStyle(
                fontSize: ResponsiveDimensions.f(14),
                color: Colors.black87,
                fontFamily: "PingAR",
              ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            labelText: labelText,
            floatingLabelBehavior: floatingLabelBehavior,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey[300]!,
                width: hasError ? 2.0 : 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                ResponsiveDimensions.w(radios!),
              ),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey[300]!,
                width: hasError ? 2.0 : 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColors.primary400,
                width: hasError ? 2.5 : 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),
            filled: true,
            fillColor: fillColor ?? Colors.grey[50],

            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.w(20),
              vertical: ResponsiveDimensions.h(16),
            ),
            hintStyle:
                hintStyle ??
                TextStyle(
                  color: Colors.grey[500],
                  fontFamily: "PingAR",
                  fontSize: ResponsiveDimensions.f(14),
                ),
            errorText: hasError ? errorText : null,
            errorStyle: TextStyle(
              fontFamily: "PingAR",
              color: Colors.red,
              fontSize: ResponsiveDimensions.f(12),
              fontWeight: FontWeight.w500,
            ),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
