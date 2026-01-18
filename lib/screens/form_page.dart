import 'package:flutter/material.dart';
import '../services/kanji_api_service.dart';
import '../widgets/kanji_form_actions.dart';
import '../widgets/kanji_form_fields.dart';

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

  final KanjiApiService _api = const KanjiApiService();

  Future<int> _createKanjiCharacter() async {
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

    return _api.createKanjiCharacter(data);
  }

  Future<void> _submitStory(int kanjiId) async {
    final data = {
      "kanji_story": storyController.text.trim(),
      "kanji_id": kanjiId,
      "is_active": isStoryActive,
    };

    return _api.submitStory(data);
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
      final story = await _api.generateAiStory(data);
      setState(() {
        storyController.text = story;
      });
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
