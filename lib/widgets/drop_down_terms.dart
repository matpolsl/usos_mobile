import 'package:flutter/material.dart';

import '../models/terms.dart';

class DropDownTerms extends StatefulWidget {
  DropDownTerms(this.items, this.setTerm, {Key? key}) : super(key: key);
  late List<Terms> items;
  final setTerm;
  @override
  _DropDownTermsState createState() => _DropDownTermsState(items, setTerm);
}

class _DropDownTermsState extends State<DropDownTerms> {
  final setTerm;
  _DropDownTermsState(this.items, this.setTerm);
  // Initial Selected Value
  late Terms dropdownvalue = items.last;

  // List of items in our dropdown menu
  late List<Terms> items;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton(
        // Initial Value
        value: dropdownvalue,

        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),

        // Array list of items
        items: items.map((Terms items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items.name),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (Terms? newValue) {
          setState(() {
            dropdownvalue = newValue!;
            setTerm(dropdownvalue.termId);
          });
        },
      ),
    );
  }
}
