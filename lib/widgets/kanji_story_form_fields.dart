import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class KanjiStoryFormFields extends StatelessWidget {
  final TextEditingController kanjiController;
  final TextEditingController storyController;
  final TextEditingController aiPromptController;
  final bool isStoryActive;
  final ValueChanged<bool> onStoryActiveChanged;
  final bool isLoadingKanji;
  final List<Map<String, dynamic>> kanjiOptions;
  final ValueChanged<Map<String, dynamic>> onKanjiSelected;

  const KanjiStoryFormFields({
    super.key,
    required this.kanjiController,
    required this.storyController,
    required this.aiPromptController,
    required this.isStoryActive,
    required this.onStoryActiveChanged,
    required this.isLoadingKanji,
    required this.kanjiOptions,
    required this.onKanjiSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Create Kanji Story",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Kanji",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              isLoadingKanji
                  ? const LinearProgressIndicator()
                  : Autocomplete<Map<String, dynamic>>(
                      displayStringForOption: (option) {
                        final kanji = option["kanji"] ?? "";
                        final meaning = option["translation"] ??
                            option["kanji_description"] ??
                            "";
                        return "$kanji - $meaning";
                      },
                      optionsBuilder: (TextEditingValue value) {
                        final query = value.text.trim().toLowerCase();
                        if (query.isEmpty) {
                          return kanjiOptions;
                        }
                        return kanjiOptions.where((option) {
                          final kanji = (option["kanji"] ?? "").toString().toLowerCase();
                          final meaning = (option["translation"] ??
                                  option["kanji_description"] ??
                                  "")
                              .toString()
                              .toLowerCase();
                          return kanji.contains(query) || meaning.contains(query);
                        });
                      },
                      onSelected: onKanjiSelected,
                      fieldViewBuilder: (context, textController, focusNode, _) {
                        textController.value = kanjiController.value;
                        return TextField(
                          controller: textController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: "Search kanji",
                            filled: true,
                            fillColor: const Color(0xffffffff),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey, width: 2),
                            ),
                          ),
                          onChanged: (value) {
                            kanjiController.text = value;
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
        CustomTextField(
          title: "Story",
          titleFontSize: 20,
          placeholder: "A story about the sun rising in the morning...",
          backgroundColor: const Color(0xffffffff),
          controller: storyController,
          borderRadius: 12,
          type: TextInputType.multiline,
          maxLines: 4,
        ),
        SwitchListTile(
          value: isStoryActive,
          onChanged: onStoryActiveChanged,
          title: const Text("Active"),
        ),
        CustomTextField(
          title: "AI Prompt (Optional)",
          titleFontSize: 20,
          placeholder: "Create a story about daily life",
          backgroundColor: const Color(0xffffffff),
          controller: aiPromptController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
      ],
    );
  }
}
