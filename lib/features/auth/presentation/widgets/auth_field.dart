import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.validator,
    required this.prefixIcon,
    this.obscureText = false,
    required this.textInputAction,
    required this.textInputType,
  });

  final TextEditingController textEditingController;
  final String hintText;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final TextInputType textInputType;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  final FocusNode _focusNode = FocusNode();
  bool _obscureText = false;
  bool hasError = false;

  @override
  void initState() {
    _obscureText = widget.obscureText;

    _focusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color getFillColor() {
    if (hasError) {
      return AppPalette.redOpacityColor;
    }
    if (_focusNode.hasFocus) {
      return AppPalette.blueOpacityColor;
    }
    return AppPalette.greyOpacityColor;
  }

  Color getIconColor() {
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
        focusNode: _focusNode,
        controller: widget.textEditingController,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        obscureText: _obscureText,
        validator: (value) {
          final errorText = widget.validator?.call(value);
          setState(() {
            if (errorText != null) {
              hasError = true;
            } else {
              hasError = false;
            }
          });
          return errorText;
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: getFillColor(),
          errorMaxLines: 3,
          prefixIcon: Icon(
            size: isPortrait ? width * 0.05 : width * 0.03,
            widget.prefixIcon,
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
