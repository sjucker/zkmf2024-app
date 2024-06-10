import 'package:flutter/material.dart';
import 'package:zkmf2024_app/constants.dart';

class FilterDialog extends StatefulWidget {
  final List<FilterCategory> categories;
  final VoidCallback callback;
  final List<bool>? favoritesOnly;
  final List<bool>? includeInPast;

  const FilterDialog(
      {super.key, required this.categories, required this.callback, this.favoritesOnly, this.includeInPast});

  @override
  State<StatefulWidget> createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: blau,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Filter",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  favoritesOnly(),
                  includeInPast(),
                  ...widget.categories.map((e) => ExpansionTile(title: Text(e.name), children: [
                        CheckboxListTile(
                          dense: true,
                          title: const Text("alle"),
                          value: e.allSelected.first,
                          tristate: true,
                          onChanged: (value) {
                            setState(() {
                              if (e.allSelected.first ?? false) {
                                e.selected.updateAll((key, value) => false);
                                e.allSelected.first = false;
                              } else {
                                e.selected.updateAll((key, value) => true);
                                e.allSelected.first = true;
                              }
                            });
                          },
                        ),
                        ...e.all.map((val) => CheckboxListTile(
                              dense: true,
                              title: Text(val, overflow: TextOverflow.ellipsis),
                              value: e.selected[val],
                              onChanged: (value) {
                                setState(() {
                                  e.selected[val] = value ?? false;
                                  var every = e.selected.values.every((e) => e);
                                  var none = !e.selected.values.any((e) => e);
                                  e.allSelected.first = every ? true : (none ? false : null);
                                });
                              },
                            ))
                      ]))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          for (var category in widget.categories) {
                            category.selected.updateAll((key, value) => true);
                            category.allSelected.first = true;
                            if (widget.favoritesOnly != null) {
                              widget.favoritesOnly![0] = false;
                            }
                          }
                        });
                      },
                      icon: const Icon(Icons.undo),
                      label: const Text("Reset"),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FilledButton(
                        onPressed: () {
                          setState(() {});
                          widget.callback.call();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget favoritesOnly() {
    var favoritesOnly = widget.favoritesOnly;
    if (favoritesOnly != null) {
      return CheckboxListTile(
        dense: true,
        title: const Text("Nur Favoriten"),
        value: favoritesOnly.first,
        onChanged: (value) {
          setState(() {
            favoritesOnly[0] = value ?? false;
          });
        },
      );
    }

    return Container();
  }

  Widget includeInPast() {
    var includeInPast = widget.includeInPast;
    if (includeInPast != null) {
      return CheckboxListTile(
          dense: true,
          title: const Text("Vergangene Einträge"),
          value: includeInPast.first,
          onChanged: (value) {
            setState(() {
              includeInPast[0] = value ?? false;
            });
          });
    }

    return Container();
  }
}

class FilterCategory {
  final String name;
  final List<String> all;
  final Map<String, bool> selected;

  // store single element in list, so it is still mutable
  final List<bool?> allSelected;

  FilterCategory(this.name, this.all, this.selected) : allSelected = [selected.values.every((e) => e)];
}
