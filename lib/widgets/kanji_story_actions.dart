import 'package:flutter/material.dart';

class KanjiStoryActions extends StatelessWidget {
  final bool isGeneratingStory;
  final VoidCallback onGenerateStory;
  final VoidCallback onSubmit;

  const KanjiStoryActions({
    super.key,
    required this.isGeneratingStory,
    required this.onGenerateStory,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: isGeneratingStory ? null : onGenerateStory,
          child: Text(isGeneratingStory ? "GENERATING..." : "GENERATE AI STORY"),
        ),
        ElevatedButton(
          onPressed: onSubmit,
          child: const Text("SUBMIT STORY"),
        ),
      ],
    );
  }
}
