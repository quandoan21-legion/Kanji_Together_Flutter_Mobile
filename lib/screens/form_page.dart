import 'package:flutter/material.dart';
import '../services/kanji_api_service.dart';
import '../widgets/kanji_form_fields.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  final kanjiController = TextEditingController();
  final meaningController = TextEditingController();
  final kanjiDescriptionController = TextEditingController();
  final translationController = TextEditingController();
  final onyomiController = TextEditingController();
  final kunyomiController = TextEditingController();
  final levelController = TextEditingController();
  final numStrokesController = TextEditingController();
  final radicalController = TextEditingController();
  final componentsController = TextEditingController();
  final writingImageUrlController = TextEditingController();
  final vocabularyController = TextEditingController();
  final examplesController = TextEditingController();

  final KanjiApiService _api = const KanjiApiService();

  Future<int> _createKanjiCharacter() async {
    final data = {
      "kanji": kanjiController.text.trim(),
      "on_pronunciation": onyomiController.text.trim(),
      "kun_pronunciation": kunyomiController.text.trim(),
      "num_strokes": int.tryParse(numStrokesController.text),
      "jlpt": int.tryParse(levelController.text),
      "kanji_description": kanjiDescriptionController.text.trim(),
      "translation": translationController.text.trim(),
      "meaning": meaningController.text.trim(),
      "radical": radicalController.text.trim(),
      "components": componentsController.text.trim(),
      "writing_image_url": writingImageUrlController.text.trim(),
      "vocabulary": vocabularyController.text.trim(),
      "examples": examplesController.text.trim(),
      "is_active": true,
    };

    return _api.createKanjiCharacter(data);
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
      await _createKanjiCharacter();

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

  void _goToOptionalFields() {
    FocusScope.of(context).unfocus();
    if (kanjiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Kanji.")),
      );
      return;
    }
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    kanjiController.dispose();
    meaningController.dispose();
    kanjiDescriptionController.dispose();
    translationController.dispose();
    onyomiController.dispose();
    kunyomiController.dispose();
    levelController.dispose();
    numStrokesController.dispose();
    radicalController.dispose();
    componentsController.dispose();
    writingImageUrlController.dispose();
    vocabularyController.dispose();
    examplesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KanjiPrimaryField(
                      kanjiController: kanjiController,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _goToOptionalFields,
                      child: const Text("NEXT"),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: submitForm,
                        child: const Text("SUBMIT"),
                      ),
                    ),
                    const SizedBox(height: 16),
                    KanjiOptionalFields(
                      meaningController: meaningController,
                      kanjiDescriptionController: kanjiDescriptionController,
                      translationController: translationController,
                      onyomiController: onyomiController,
                      kunyomiController: kunyomiController,
                      levelController: levelController,
                      numStrokesController: numStrokesController,
                      radicalController: radicalController,
                      componentsController: componentsController,
                      writingImageUrlController: writingImageUrlController,
                      vocabularyController: vocabularyController,
                      examplesController: examplesController,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
