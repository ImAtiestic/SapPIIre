import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:sappiire/constants/app_colors.dart';

class InfoInputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final List<List<dynamic>>? icon;
  final bool isChecked;
  final Function(bool?) onCheckboxChanged;
  final Function(String) onTextChanged;

  const InfoInputField({
    super.key,
    required this.label,
    this.initialValue,
    this.icon,
    required this.isChecked,
    required this.onCheckboxChanged,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0), // Slightly tighter vertical spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.w500, // Medium weight is cleaner for small text
                  fontSize: 13, // Standard mobile label size
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 20, // Smaller hit box for the label-side checkbox
                width: 20,
                child: Checkbox(
                  value: isChecked,
                  onChanged: onCheckboxChanged,
                  activeColor: AppColors.buttonPurple,
                  side: const BorderSide(color: Colors.white70, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // Better gap between label and box
          TextFormField(
            initialValue: initialValue,
            onChanged: onTextChanged,
            // Standardizing input text to 16px
            style: const TextStyle(color: Colors.white, fontSize: 16), 
            decoration: InputDecoration(
              isDense: true, // Shrinks the height to be more compact/modern
              prefixIcon: icon != null
                  ? Padding(
                      padding: const EdgeInsets.all(10.0), // Reduced padding for better centering
                      child: HugeIcon(icon: icon!, color: Colors.white70, size: 18),
                    )
                  : null,
              // Vertical 12 + Font Size (16) + Vertical 12 ≈ 48-50px total height
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Softer radius
                borderSide: const BorderSide(color: Colors.white54, width: 1.2), // Slightly thinner border
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}