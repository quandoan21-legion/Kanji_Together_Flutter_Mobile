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

  @override
  void dispose() {
    kanjiController.dispose();
    meaningController.dispose();
    onyomiController.dispose();
    kunyomiController.dispose();
    levelController.dispose();
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
                ),
                KanjiFormActions(
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
