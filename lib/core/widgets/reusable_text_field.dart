import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
class ReusableTextField extends ConsumerWidget {
  final String label;
  final String? hintText;
  final String? errorText;
  final IconData? icon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool isReadOnly;
  final bool disabled;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  /// ⭐️ NEW: Whether this field is required
  final bool isMandatory;

  const ReusableTextField({
    super.key,
    required this.label,
    this.hintText,
    this.errorText,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = false,
    this.disabled = false,
    this.onTap,
    required this.controller,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
    this.isMandatory = false, // ⭐️ Default to false
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labelColor = disabled ? Colors.grey : Colors.black54;
    final inputTextColor = disabled ? Colors.grey[600]! : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, size: 14, color: labelColor),
              if (icon != null) const SizedBox(width: 6),
              ReusableText(
                text: label,
                style: AppTextStyle(textColor: labelColor).labelSmall,
              ),
              if (isMandatory)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: isReadOnly || disabled,
            enabled: !disabled,
            onTap: disabled ? null : onTap,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: AppTextStyle(textColor: inputTextColor).titleSmall,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              errorStyle: AppTextStyle(textColor: Colors.red).labelSmall,
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
              isDense: true,
              hintText: hintText,
              errorText: errorText,
              hintStyle: AppTextStyle(textColor: Colors.grey).labelRegular,
              contentPadding: const EdgeInsets.only(top: 8, bottom: 6),
              suffixIcon: suffixIcon,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
