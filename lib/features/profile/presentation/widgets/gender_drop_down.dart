import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../domain/enums/gender.dart';

class CustomGenderDropdown extends StatefulWidget {
  const CustomGenderDropdown({
    super.key,
    required this.onChanged,
    this.initialValue = Gender.notSpecified,
    this.helperText,
    this.isEnabled = true,
  });

  final Function(Gender) onChanged;
  final Gender initialValue;
  final String? helperText;
  final bool isEnabled;

  @override
  State<CustomGenderDropdown> createState() => _CustomGenderDropdownState();
}

class _CustomGenderDropdownState extends State<CustomGenderDropdown> {
  late Gender selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color getFillColor() {
    if (!widget.isEnabled) {
      return AppPalette.greyOpacityColor.withAlpha(100);
    }
    return AppPalette.greyOpacityColor;
  }

  Color getIconColor() {
    if (!widget.isEnabled) {
      return AppPalette.greyColor;
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
      child: DropdownButtonFormField2<Gender>(
        value: selectedGender,
        isExpanded: true,
        onChanged:
            widget.isEnabled
                ? (Gender? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedGender = newValue;
                    });
                    widget.onChanged(newValue);
                  }
                }
                : null,
        items:
            Gender.values
                .map(
                  (gender) => DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(
                      gender.displayValue,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
                .toList(),
        decoration: InputDecoration(
          helperText: widget.helperText,
          helperMaxLines: 2,
          errorMaxLines: 3,
          filled: true,
          fillColor: getFillColor(),
          prefixIcon: Icon(
            Icons.wc,
            color: getIconColor(),
            size: isPortrait ? width * 0.05 : width * 0.03,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(Icons.arrow_drop_down, color: getIconColor()),
          iconSize: isPortrait ? width * 0.05 : width * 0.03,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          isOverButton: true,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
