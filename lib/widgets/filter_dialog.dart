import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';

class FilterDialog extends StatefulWidget {
  final List<FilterCategory> categories;
  final VoidCallback callback;

  const FilterDialog({super.key, required this.categories, required this.callback});

  @override
  State<StatefulWidget> createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Filter"),
      backgroundColor: blau,
      contentPadding: const EdgeInsets.all(10),
      children: [
        ...widget.categories.map((e) => ExpansionTile(title: Text(e.name), children: [
              ...e.all.map((val) => CheckboxListTile(
                    dense: true,
                    title: Text(val, overflow: TextOverflow.ellipsis),
                    value: e.selected[val],
                    onChanged: (value) {
                      setState(() {
                        e.selected[val] = value ?? false;
                      });
                    },
                  ))
            ])),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              for (var category in widget.categories) {
                category.selected.forEach((key, value) {
                  category.selected[key] = true;
                });
              }
            });
          },
          icon: const Icon(Icons.undo),
          label: const Text("Reset"),
        ),
        FilledButton(
            onPressed: () {
              setState(() {});
              widget.callback.call();
              Navigator.of(context).pop();
            },
            child: const Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}

class FilterCategory {
  final String name;
  final List<String> all;
  final Map<String, bool> selected;

  FilterCategory(this.name, this.all, this.selected);
}
