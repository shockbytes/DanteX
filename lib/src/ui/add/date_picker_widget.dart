import 'package:dantex/src/util/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatefulWidget {
  final DateTime? preSelectedDate;
  final Function(DateTime date) onDateSelected;

  const DatePickerWidget({
    required this.onDateSelected,
    this.preSelectedDate,
    super.key,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    _selectedDateTime = widget.preSelectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'date-picker.title'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            border: Border.all(width: 0.7),
          ),
          child: InkWell(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 16),
                Center(
                  child: Text(
                    _selectedDateTime?.formatDefault() ?? 'date-picker.empty'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            onTap: () async {
              final DateTime? selectedDateTime = await showDatePicker(
                context: context,
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );

              if (selectedDateTime != null) {
                widget.onDateSelected(selectedDateTime);

                setState(() {
                  _selectedDateTime = selectedDateTime;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
