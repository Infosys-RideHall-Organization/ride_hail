import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.validator,
    required this.prefixIcon,
    required this.textInputAction,
    required this.textInputType,
    this.obscureText = false,
    this.helperText,
    this.isEnabled = true,
  });

  final TextEditingController textEditingController;
  final String hintText;

  final String? helperText;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool isEnabled;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color getFillColor() {
    if (!widget.isEnabled) {
      return AppPalette.greyOpacityColor.withAlpha(100);
    }
    if (hasError) {
      return AppPalette.redOpacityColor;
    }
    if (_focusNode.hasFocus) {
      return AppPalette.blueOpacityColor;
    }
    return AppPalette.greyOpacityColor;
  }

  Color getIconColor() {
    if (!widget.isEnabled) {
      return AppPalette.greyColor;
    }
    if (hasError) {
      return AppPalette.redColor;
    }
    if (_focusNode.hasFocus) {
      return AppPalette.primaryColor;
    }
    return AppPalette.greyColor;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    return SizedBox(
      width: width * 0.9,
      child: TextFormField(
        enabled: widget.isEnabled, // Disable input if false
        focusNode: _focusNode,
        controller: widget.textEditingController,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        obscureText: _obscureText,
        validator: (value) {
          final errorText = widget.validator?.call(value);
          setState(() {
            hasError = errorText != null;
          });
          return errorText;
        },
        decoration: InputDecoration(
          helperMaxLines: 2,
          helperText: widget.helperText,
          hintText: widget.hintText,
          filled: true,
          fillColor: getFillColor(),
          errorMaxLines: 3,
          prefixIcon: Icon(
            widget.prefixIcon,
            size: isPortrait ? width * 0.05 : width * 0.03,
            color: getIconColor(),
          ),
          suffixIcon:
              widget.obscureText
                  ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: getIconColor(),
                      size: isPortrait ? width * 0.05 : width * 0.03,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
