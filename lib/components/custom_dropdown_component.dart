import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CustomDropdown extends StatelessWidget {
  final List<DropdownMenuItem> dropdownItems;
  final String selectedValue;
  final Function onChanged;
  final String hintText;

  CustomDropdown(
      {this.dropdownItems, this.selectedValue, this.onChanged, this.hintText});

  @override
  Widget build(BuildContext context) {
    return SearchableDropdown.single(
      displayClearIcon: false,
      doneButton: null,
      items: dropdownItems,
      value: selectedValue,
      hint: hintText,
      onChanged: onChanged,
      displayItem: (item, selected) {
        return (Row(children: [
          selected
              ? Icon(
                  Icons.radio_button_checked,
                  color: Colors.green,
                )
              : Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey,
                ),
          SizedBox(width: 10),
          Expanded(
            child: item,
          ),
        ]));
      },
      isExpanded: true,
    );
  }
}
