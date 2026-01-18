import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import '../components/kanji_form_actions.dart';
import '../components/kanji_form_fields.dart';

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
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
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
    }
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
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
    FocusScope.of(context).unfocus();
    if (kanjiController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Kanji.")),
      );
      return;
    }

    try {
      final kanjiId = await _createKanjiCharacter();

      if (kanjiId == null) {
        throw Exception("Missing kanji id in response.");
      }

      if (storyController.text.trim().isNotEmpty) {
        await _submitStory(kanjiId);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kanji created successfully.")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit kanji: $e")),
      );
      return;
    }
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
                KanjiFormFields(
                  kanjiController: kanjiController,
                  meaningController: meaningController,
                  onyomiController: onyomiController,
                  kunyomiController: kunyomiController,
                  levelController: levelController,
                  storyController: storyController,
                  aiPromptController: aiPromptController,
                  isStoryActive: isStoryActive,
                  onStoryActiveChanged: (value) {
                    setState(() {
                      isStoryActive = value;
                    });
                  },
                ),
                KanjiFormActions(
                  isGeneratingStory: isGeneratingStory,
                  onGenerateStory: generateAiStory,
                  onSubmit: submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
