import 'package:flutter/material.dart';

class FormDropdown extends StatelessWidget {
  final String selectedForm;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const FormDropdown({
    super.key,
    required this.selectedForm,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedForm,
          isExpanded: true,
          items: items.map((val) => DropdownMenuItem(
            value: val,
            child: Text(val, style: const TextStyle(color: Color(0xFF0D3299))),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}