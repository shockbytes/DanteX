import 'package:flutter/material.dart';

class BookCoverPickerWidget extends StatelessWidget {
  const BookCoverPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO Handle book cover picks
    return Container(
      width: 100,
      height: 100,
      color: Colors.white,
      child: const Center(
        child: Text('Pick Image'),
      ),
    );
  }
}
