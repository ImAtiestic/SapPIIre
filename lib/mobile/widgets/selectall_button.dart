import 'package:flutter/material.dart';

class SelectAllButton extends StatelessWidget {
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  const SelectAllButton({
    super.key,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Translucent background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Select All",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          const SizedBox(width: 4),
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
            activeColor: const Color(0xFF4A69D4),
            checkColor: Colors.white,
            side: const BorderSide(color: Colors.white, width: 2),
          ),
        ],
      ),
    );
  }
}