import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final kanjiController = TextEditingController();
  final meaningController = TextEditingController();
  final onyomiController = TextEditingController();
  final kunyomiController = TextEditingController();
  final levelController = TextEditingController();
  final storyController = TextEditingController();
  final aiPromptController = TextEditingController();

  bool isStoryActive = true;
  bool isGeneratingStory = false;

  static const String _baseUrl = "https://b0cf4586ffec.ngrok-free.app";

  int? _parseKanjiId(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final data = decoded["data"];
        if (data is Map<String, dynamic>) {
          final id = data["id"];
          if (id is int) return id;
          return int.tryParse(id?.toString() ?? "");
        }
        if (data is int) return data;
        final id = decoded["id"];
        if (id is int) return id;
        return int.tryParse(id?.toString() ?? "");
      }
    } catch (_) {}
    return null;
  }

  Future<int?> _createKanjiCharacter() async {
    final data = {
      "kanji": kanjiController.text.trim(),
      "on_pronunciation": onyomiController.text.trim(),
      "kun_pronunciation": kunyomiController.text.trim(),
      "num_strokes": 0,
      "jlpt": int.tryParse(levelController.text),
      "kanji_description": meaningController.text.trim(),
      "translation": meaningController.text.trim(),
      "is_active": true,
      "create_by": 1,
    };

    final response = await http.post(
      Uri.parse("$_baseUrl/api/v1/kanji-characters"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return _parseKanjiId(response.body);
    }
    return null;
  }

  Future<bool> _submitStory(int kanjiId) async {
    final data = {
      "kanji_story": storyController.text.trim(),
      "kanji_id": kanjiId,
      "is_active": isStoryActive,
    };

    final response = await http.post(
      Uri.parse("$_baseUrl/api/v1/kanji-stories"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> generateAiStory() async {
    if (kanjiController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Kanji to generate story.")),
      );
      return;
    }

    setState(() => isGeneratingStory = true);

    final data = {
      "kanji": kanjiController.text.trim(),
      "custom_prompt": aiPromptController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/api/v1/ai-kanji/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final story = (decoded["data"]?["story"] ?? "").toString();

        if (story.isEmpty) {
          throw Exception("Empty story returned.");
        }

        setState(() {
          storyController.text = story;
        });
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate story: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isGeneratingStory = false);
      }
    }
  }

  Future<void> submitForm() async {
    if (kanjiController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Kanji.")),
      );
      return;
    }

    final kanjiId = await _createKanjiCharacter();
    if (kanjiId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create kanji.")),
      );
      return;
    }

    if (storyController.text.trim().isNotEmpty) {
      final storyCreated = await _submitStory(kanjiId);
      if (!storyCreated) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kanji created, but story failed.")),
        );
        return;
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kanji created successfully.")),
    );
  }

  @override
  void dispose() {
    kanjiController.dispose();
    meaningController.dispose();
    onyomiController.dispose();
    kunyomiController.dispose();
    levelController.dispose();
    storyController.dispose();
    aiPromptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Create Kanji",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                CustomTextField(
                  title: "Kanji",
                  titleFontSize: 20,
                  placeholder: "会",
                  backgroundColor: const Color(0xffffffff),
                  controller: kanjiController,
                  borderRadius: 12,
                  type: TextInputType.text,
                ),
                CustomTextField(
                  title: "Ý Nghĩa",
                  titleFontSize: 20,
                  placeholder: "cuộc họp; họp; hội nghị",
                  backgroundColor: const Color(0xffffffff),
                  controller: meaningController,
                  borderRadius: 12,
                  type: TextInputType.text,
                ),
                CustomTextField(
                  title: "Âm On",
                  titleFontSize: 20,
                  placeholder: "カイ    エ",
                  backgroundColor: const Color(0xffffffff),
                  controller: onyomiController,
                  borderRadius: 12,
                  type: TextInputType.text,
                ),
                CustomTextField(
                  title: "Âm Kun",
                  titleFontSize: 20,
                  placeholder: "あ.う    あ.わせる    あつ.まる",
                  backgroundColor: const Color(0xffffffff),
                  controller: kunyomiController,
                  borderRadius: 12,
                  type: TextInputType.text,
                ),
                CustomTextField(
                  title: "Level",
                  titleFontSize: 20,
                  placeholder: "Level 70",
                  backgroundColor: const Color(0xffffffff),
                  controller: levelController,
                  borderRadius: 12,
                  type: TextInputType.number,
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
                  onChanged: (value) {
                    setState(() {
                      isStoryActive = value;
                    });
                  },
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
                ElevatedButton(
                  onPressed: isGeneratingStory ? null : generateAiStory,
                  child: Text(isGeneratingStory ? "GENERATING..." : "GENERATE AI STORY"),
                ),
                ElevatedButton(
                  onPressed: submitForm,
                  child: const Text("SUBMIT"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
