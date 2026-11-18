import 'package:material_ui/material_ui.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    this.fieldKey,
    this.controller,
    this.hintText,
    this.helperText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.autofocus = false,
    this.enabled = true,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  final String label;
  final Key? fieldKey;
  final TextEditingController? controller;
  final String? hintText;
  final String? helperText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final int? minLines;
  final bool autofocus;
  final bool enabled;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      autofocus: autofocus,
      enabled: enabled,
      obscureText: obscureText,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
