import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleChoiceDialog<T> extends StatefulWidget {
  final String title;
  final IconData icon;
  final List<Choice> choices;
  final Function(T) onValueSelected;
  final T? selectedValue;

  const SingleChoiceDialog({
    super.key,
    required this.title,
    required this.icon,
    required this.choices,
    required this.onValueSelected,
    required this.selectedValue,
  });

  @override
  State<SingleChoiceDialog<T>> createState() => _SingleChoiceDialogState<T>();
}

class _SingleChoiceDialogState<T> extends State<SingleChoiceDialog<T>> {
  late T _choiceSelection;

  @override
  void initState() {
    _choiceSelection = widget.selectedValue ?? widget.choices.first.key;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AlertDialog.adaptive(
        title: Text(widget.title),
        icon: Icon(widget.icon),
        content: Column(
          children: widget.choices
              .map(
                (Choice choice) => ListTile(
                  title: Text(choice.title),
                  leading: Radio<T>(
                    value: choice.key,
                    groupValue: _choiceSelection,
                    onChanged: (T? value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _choiceSelection = value;
                      });
                    },
                  ),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onValueSelected(_choiceSelection);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)!.select,
            ),
          ),
        ],
      ),
    );
  }
}

class Choice<T> {
  final String title;
  final T key;

  Choice({
    required this.title,
    required this.key,
  });
}
