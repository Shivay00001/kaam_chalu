import 'package:flutter/material.dart';

/// Reusable text field with bilingual labels
/// Designed for non-tech users with clear visual feedback
class KaamTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelEn;
  final String labelHi;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? hint;
  final bool enabled;

  const KaamTextField({
    super.key,
    required this.controller,
    required this.labelEn,
    required this.labelHi,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.hint,
    this.enabled = true,
  });

  @override
  State<KaamTextField> createState() => _KaamTextFieldState();
}

class _KaamTextFieldState extends State<KaamTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText && _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelEn,
        hintText: widget.hint ?? widget.labelHi,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Colors.grey[600])
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
