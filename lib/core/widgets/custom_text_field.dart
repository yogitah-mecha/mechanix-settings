import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final String obscuringCharacter;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.backgroundVariant,
        borderRadius: BorderRadius.circular(8),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyLarge,
        onChanged: onChanged,
        onSubmitted: (value) {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          }
          onSubmitted?.call(value);
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.displaySmall,
          prefixIcon: prefixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                  child: prefixIcon,
                ),
          suffixIcon: suffixIcon == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                  child: suffixIcon,
                ),
        ),
      ),
    );
  }
}
