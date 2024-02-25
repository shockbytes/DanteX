import 'package:dantex/src/util/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final DateController controller;
  final Function(DateTime date)? onDateSelected;

  const DatePickerWidget({
    required this.controller,
    this.onDateSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'date-picker.title'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            border: Border.all(
              width: 0.7,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: InkWell(
            child: ValueListenableBuilder<DateTime?>(
              valueListenable: controller,
              builder: (context, selectedDateTime, _) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(width: 16),
                    Center(
                      child: Text(
                        selectedDateTime?.formatDefault() ?? 'date-picker.empty'.tr(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                  ],
                );
              },
            ),
            onTap: () async {
              final DateTime? selectedDateTime = await showDatePicker(
                context: context,
                firstDate: DateTime(1940),
                lastDate: DateTime.now(),
              );

              if (selectedDateTime != null) {
                onDateSelected?.call(selectedDateTime);
                controller.value = selectedDateTime;
              }
            },
          ),
        ),
      ],
    );
  }
}

class DateController extends ValueNotifier<DateTime?> {
  DateController(super.value);
}
