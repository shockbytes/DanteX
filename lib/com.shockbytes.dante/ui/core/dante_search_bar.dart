import 'package:flutter/material.dart';

class DanteSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Search your library...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87
              ),
            ),
          ),
        ],
      ),
    );
  }
}
