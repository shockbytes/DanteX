import 'package:dantex/models/book_label.dart';
import 'package:dantex/providers/repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateLabelDialog extends ConsumerStatefulWidget {
  const CreateLabelDialog({super.key});

  @override
  ConsumerState<CreateLabelDialog> createState() => _CreateLabelDialogState();
}

class _CreateLabelDialogState extends ConsumerState<CreateLabelDialog> {
  final _nameController = TextEditingController();
  Color _labelColor = const Color(0xFFF44336);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('book_detail.create_label').tr(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            buildCounter: (
              context, {
              required currentLength,
              required maxLength,
              required isFocused,
            }) {
              return Text('$currentLength/16');
            },
            controller: _nameController,
            maxLength: 16,
            decoration: InputDecoration(
              labelText: 'book_detail.name'.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
            width: 240,
            child: ColorPicker(
              color: _labelColor,
              enableShadesSelection: false,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.primary: false,
                ColorPickerType.accent: false,
                ColorPickerType.bw: false,
                ColorPickerType.custom: true,
                ColorPickerType.wheel: false,
              },
              onColorChanged: (color) => setState(() => _labelColor = color),
              customColorSwatchesAndNames: _colorSwatches,
              borderRadius: 22,
              columnSpacing: 10,
              runSpacing: 10,
              spacing: 10,
              padding: EdgeInsets.zero,
              title: Text(
                'book_detail.chose_color',
                style: Theme.of(context).textTheme.labelMedium,
              ).tr(),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton.icon(
          onPressed: () async {
            await ref.read(bookLabelRepositoryProvider).addLabel(
                  BookLabel(
                    id: '-1',
                    title: _nameController.text,
                    hexColor: _labelColor.hexAlpha,
                  ),
                );
          },
          label: const Text('book_detail.create_label').tr(),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

final Map<ColorSwatch<Object>, String> _colorSwatches = {
  ColorTools.createPrimarySwatch(const Color(0xFFF44336)): 'Red',
  ColorTools.createPrimarySwatch(const Color(0xFF9C27B0)): 'Purple',
  ColorTools.createPrimarySwatch(const Color(0xFFE91E63)): 'Pink',
  ColorTools.createPrimarySwatch(const Color(0xFFFF9800)): 'Orange',
  ColorTools.createPrimarySwatch(const Color(0xFF4CAF50)): 'Green',
  ColorTools.createPrimarySwatch(const Color(0xFF009688)): 'Teal',
  ColorTools.createPrimarySwatch(const Color(0xFF00DD99)): 'Custom Greenish',
  ColorTools.createPrimarySwatch(const Color(0xFF3F51B5)): 'Indigo',
  ColorTools.createPrimarySwatch(const Color(0xFF9F6459)): 'Brownish',
  ColorTools.createPrimarySwatch(const Color(0xFF03A9F4)): 'Light Blue',
};
