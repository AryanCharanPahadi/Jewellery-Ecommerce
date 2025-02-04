import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isObscure;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool isDateField; // New parameter to identify if it's a date field

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.validator,
    this.isObscure = false,
    this.readOnly = false,
    this.onTap,
    this.isDateField = false, // Defaults to false if not a date field
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      obscureText: isObscure,
      readOnly: readOnly,
      onTap: () async {
        if (isDateField) {
          // Show date picker if this is a date field
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (selectedDate != null) {
            controller.text =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"; // Format the selected date
          }
        } else if (onTap != null) {
          // Call the custom onTap if it's not a date field
          onTap!();
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
