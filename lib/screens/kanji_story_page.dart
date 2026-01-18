import 'package:flutter/material.dart';
import '../services/kanji_api_service.dart';
import '../widgets/kanji_story_actions.dart';
import '../widgets/kanji_story_form_fields.dart';

class KanjiStoryPage extends StatefulWidget {
  const KanjiStoryPage({super.key});

  @override
  State<KanjiStoryPage> createState() => _KanjiStoryPageState();
}

class _KanjiStoryPageState extends State<KanjiStoryPage> {
  final _formKey = GlobalKey<FormState>();

  final kanjiController = TextEditingController();
  final storyController = TextEditingController();
  final aiPromptController = TextEditingController();

  bool isStoryActive = true;
  bool isGeneratingStory = false;
  bool isLoadingKanji = true;

  List<Map<String, dynamic>> kanjiOptions = [];
  int? selectedKanjiId;

  final KanjiApiService _api = const KanjiApiService();

  @override
  void initState() {
    super.initState();
    _loadKanjiOptions();
  }

  Future<void> _loadKanjiOptions() async {
    setState(() => isLoadingKanji = true);
    try {
      final list = await _api.fetchKanjiList();
      setState(() {
        kanjiOptions = list
            .whereType<Map<String, dynamic>>()
            .toList();
        isLoadingKanji = false;
      });
    } catch (e) {
      setState(() => isLoadingKanji = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load kanji list: $e")),
      );
    }
  }

  void _handleKanjiSelected(Map<String, dynamic> option) {
    setState(() {
      selectedKanjiId = option["id"] is int
          ? option["id"] as int
          : int.tryParse(option["id"]?.toString() ?? "");
      kanjiController.text = option["kanji"]?.toString() ?? kanjiController.text;
    });
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

  Future<void> submitStory() async {
    FocusScope.of(context).unfocus();
    if (selectedKanjiId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a Kanji.")),
      );
      return;
    }
    if (storyController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a story.")),
      );
      return;
    }

    final data = {
      "kanji_story": storyController.text.trim(),
      "kanji_id": selectedKanjiId,
      "status": "PENDING",
      "user_email": "qdon21@gmail.com",
      "is_active": isStoryActive,
    };

    try {
      await _api.createKanjiStory(data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Story created successfully.")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit story: $e")),
      );
    }
  }

  @override
  void dispose() {
    kanjiController.dispose();
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
                KanjiStoryFormFields(
                  kanjiController: kanjiController,
                  storyController: storyController,
                  aiPromptController: aiPromptController,
                  isStoryActive: isStoryActive,
                  onStoryActiveChanged: (value) {
                    setState(() {
                      isStoryActive = value;
                    });
                  },
                  isLoadingKanji: isLoadingKanji,
                  kanjiOptions: kanjiOptions,
                  onKanjiSelected: _handleKanjiSelected,
                ),
                KanjiStoryActions(
                  isGeneratingStory: isGeneratingStory,
                  onGenerateStory: generateAiStory,
                  onSubmit: submitStory,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
