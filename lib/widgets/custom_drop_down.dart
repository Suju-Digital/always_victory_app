import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final String Function(T) itemText;
  final ValueChanged<T?> onChanged;
  final Widget? prefixIcon;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.itemText,
    required this.onChanged,
    this.hint = "Select",
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 10),
            ],
            Expanded(
              child: DropdownButton<T>(
                value: value,
                isExpanded: true,
                hint: Text(hint),
                items: items.map((item) {
                  return DropdownMenuItem<T>(
                    value: item,
                    child: Text(itemText(item)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}