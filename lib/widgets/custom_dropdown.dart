import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> options;
  final String initialValue;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.options,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: initialValue,
          icon: SvgPicture.asset('lib/assets/icons/dropdown.svg',
              width: 16, height: 16),
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isExpanded: false, // ป้องกัน DropdownButton ขยายเต็มความกว้าง
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
