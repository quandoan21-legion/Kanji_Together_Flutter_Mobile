import 'package:flutter/material.dart';

class KanjiFormActions extends StatelessWidget {
  final VoidCallback onSubmit;

  const KanjiFormActions({
    super.key,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text("SUBMIT"),
        ),
      ],
    );
  }
}
