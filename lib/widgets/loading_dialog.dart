import 'dart:ui';

import 'package:flutter/material.dart';

import 'progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  const LoadingDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.red.shade800.withOpacity(0.7),
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgressIndicator(),
          const SizedBox(height: 10),
          Text(
            "$message Please wait...",
            style: const TextStyle(
                color: Colors.white, fontFamily: "Lobster-Regular"),
          ),
        ],
      ),
    );
  }
}
