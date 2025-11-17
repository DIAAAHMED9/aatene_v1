import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:flutter/material.dart';

class TextFiledAatene extends StatelessWidget {
  const TextFiledAatene({
    super.key,
    required this.isRTL,
    required this.hintText,
     this.isError,
     this.errorValue,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.textInputType,
    this.controller,
    this.heightTextFiled,
     this.fillColor,
  });

  final bool isRTL;
  final String hintText;
  final String? errorValue;
  final Function(String)? onChanged;
  final bool? obscureText;
  final bool? isError;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final double? heightTextFiled;
  final Color?fillColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: heightTextFiled,
          child: TextFormField(
            controller: controller,
            keyboardType: textInputType,
            obscureText: obscureText ?? false,
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
                borderSide: BorderSide(
                  color: isError??false ? Colors.red : Colors.grey[300]!,
                  width: isError??false ? 2.0 : 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
                borderSide: BorderSide(
                  color: isError??false ? Colors.red : Colors.grey[300]!,
                  width: isError??false ? 2.0 : 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
                borderSide: BorderSide(
                  color: isError??false ? Colors.red : Colors.blue,
                  width: isError??false ? 2.0 : 1.0,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(50)),
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
              filled: true,
              fillColor: isError??false ? Colors.transparent :fillColor?? Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.w(20),
                vertical: ResponsiveDimensions.h(16),
              ),
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: ResponsiveDimensions.f(14),
              ),
            ),
          ),
        ),
        if (isError??false)
          Padding(
            padding: EdgeInsets.only(
              top: ResponsiveDimensions.h(8),
              right: isRTL ? 0 : ResponsiveDimensions.w(12),
              left: isRTL ? ResponsiveDimensions.w(12) : 0,
            ),
            child: Text(
              errorValue??'',
              style: TextStyle(
                color: Colors.red,
                fontSize: ResponsiveDimensions.f(12),
                fontWeight: FontWeight.w500,
              ),
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
            ),
          ),
      ],
    );
  }
}
