import 'package:carousel_slider/carousel_slider.dart';
import 'package:dantex/src/data/book/entity/book.dart';
import 'package:dantex/src/data/book/entity/book_label.dart';
import 'package:dantex/src/providers/labels.dart';
import 'package:dantex/src/providers/repository.dart';
import 'package:dantex/src/ui/core/dante_components.dart';
import 'package:dantex/src/ui/core/generic_error_widget.dart';
import 'package:dantex/src/ui/core/platform_components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddLabelBottomSheet extends ConsumerWidget {
  final Book book;

  const AddLabelBottomSheet({
    required this.book,
  }) : super(key: const ValueKey('add-label-bottom-sheet'));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBookLabels = ref.watch(getBookLabelsProvider);
    return BottomSheet(
      onClosing: () {},
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: allBookLabels.when(
          data: (allLabels) {
            final availableLabels = allLabels.where(
              (label) => !book.labels.contains(label),
            );
            return Column(
              children: [
                Text(
                  'add_label_bottom_sheet.pick_a_label'.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                Visibility(
                  visible: availableLabels.isNotEmpty,
                  replacement: Text(
                    key: const ValueKey('no-labels-available'),
                    'add_label_bottom_sheet.no_labels_available'.tr(),
                    textAlign: TextAlign.center,
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 21 / 9,
                      viewportFraction: 0.4,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    ),
                    items: availableLabels
                        .map(
                          (bookLabel) => _LabelCard(
                            book: book,
                            bookLabel: bookLabel,
                          ),
                        )
                        .toList(),
                  ),
                ),
                DanteOutlinedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add),
                      Text('add_label_bottom_sheet.create_new_label'.tr()),
                    ],
                  ),
                  onPressed: () async => showDanteDialog(
                    context,
                    title: 'add_label_bottom_sheet.create_new_label'.tr(),
                    content: const _CreateLabelDialog(),
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) {
            return GenericErrorWidget(error);
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                key: ValueKey('add-labels-loading'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LabelCard extends ConsumerWidget {
  final Book book;
  final BookLabel bookLabel;

  const _LabelCard({
    required this.book,
    required this.bookLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton(
                onSelected: (item) async {
                  await ref.read(bookLabelRepositoryProvider).deleteBookLabel(
                        bookLabel.id,
                      );

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outlined,
                          color: Colors.red,
                        ),
                        Text('delete'.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            key: ValueKey('label-card-${bookLabel.title}'),
            onTap: () async {
              Navigator.of(context).pop();
              await ref.read(bookRepositoryProvider).addLabelToBook(
                    book.id,
                    bookLabel,
                  );
            },
            child: Icon(
              Icons.sell_rounded,
              color: bookLabel.hexColor.toColor,
              size: 80,
            ),
          ),
          Text(
            bookLabel.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CreateLabelDialog extends ConsumerStatefulWidget {
  const _CreateLabelDialog()
      : super(key: const ValueKey('create-label-dialog'));

  @override
  createState() => _CreateLabelDialogState();
}

class _CreateLabelDialogState extends ConsumerState<_CreateLabelDialog> {
  Color screenPickerColor = const Color(0xFF7D20FF);
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<ColorSwatch<Object>, String> customSwatches =
        <ColorSwatch<Object>, String>{
      ColorTools.createPrimarySwatch(const Color(0xFF7D20FF)): 'Purple',
      ColorTools.createPrimarySwatch(const Color(0xFFFFA500)): 'Orange',
      ColorTools.createPrimarySwatch(const Color(0xFFFF00FF)): 'Pink',
      ColorTools.createPrimarySwatch(const Color(0xFFCD853F)): 'Brown',
      ColorTools.createPrimarySwatch(const Color(0xFF00E5EE)): 'Cyan',
      ColorTools.createPrimarySwatch(const Color(0xFF00FF00)): 'Lime Green',
      ColorTools.createPrimarySwatch(const Color(0xFF0000FF)): 'Blue',
      ColorTools.createPrimarySwatch(const Color(0xFFFF0000)): 'Red',
      ColorTools.createPrimarySwatch(const Color(0xFF006400)): 'Dark Green',
      ColorTools.createPrimarySwatch(const Color(0xFFEE82EE)): 'Lavender',
    };

    return Material(
      child: Column(
        children: [
          DanteTextField(
            controller: textController,
            hint: 'add_label_bottom_sheet.name'.tr(),
            formatter: LengthLimitingTextInputFormatter(16),
          ),
          ColorPicker(
            color: screenPickerColor,
            enableShadesSelection: false,
            pickersEnabled: const <ColorPickerType, bool>{
              ColorPickerType.primary: false,
              ColorPickerType.accent: false,
              ColorPickerType.bw: false,
              ColorPickerType.custom: true,
              ColorPickerType.wheel: false,
            },
            onColorChanged: (Color color) =>
                setState(() => screenPickerColor = color),
            customColorSwatchesAndNames: customSwatches,
            width: 36,
            height: 36,
            borderRadius: 22,
            title: Text(
              'add_label_bottom_sheet.choose_a_color'.tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          DanteOutlinedButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add),
                Text('add_label_bottom_sheet.create_new_label'.tr()),
              ],
            ),
            onPressed: () async {
              Navigator.of(context).pop();

              await ref.read(bookLabelRepositoryProvider).createBookLabel(
                    BookLabel(
                      id: '',
                      title: textController.text,
                      hexColor: screenPickerColor.value.toRadixString(16),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }
}
