import 'package:flutter/material.dart';
import '../services/kanji_api_service.dart';
import '../widgets/flash_card_dialog.dart';

class KanjiDetailPage extends StatefulWidget {
  final Map<String, dynamic> kanji;

  const KanjiDetailPage({super.key, required this.kanji});

  @override
  State<KanjiDetailPage> createState() => _KanjiDetailPageState();
}

class _KanjiDetailPageState extends State<KanjiDetailPage> {
  final KanjiApiService _api = const KanjiApiService();
  bool isLoadingStories = true;
  List<Map<String, dynamic>> stories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  String _valueOrEmpty(dynamic value) => value?.toString() ?? "";

  int? _kanjiIdFromMap(Map<String, dynamic> kanji) {
    final id = kanji["id"];
    if (id is int) return id;
    return int.tryParse(id?.toString() ?? "");
  }

  Future<void> _loadStories() async {
    final kanjiId = _kanjiIdFromMap(widget.kanji);
    if (kanjiId == null) {
      setState(() => isLoadingStories = false);
      return;
    }
    try {
      final list = await _api.fetchKanjiStories();
      final filtered = list
          .whereType<Map<String, dynamic>>()
          .where((story) {
            final id = story["kanji_id"];
            final storyKanjiId =
                id is int ? id : int.tryParse(id?.toString() ?? "");
            return storyKanjiId == kanjiId;
          })
          .toList();
      if (!mounted) return;
      setState(() {
        stories = filtered;
        isLoadingStories = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingStories = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load stories: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kanjiChar = _valueOrEmpty(widget.kanji["kanji"]);
    final meaning =
        _valueOrEmpty(widget.kanji["translation"] ?? widget.kanji["meaning"]);
    final description = _valueOrEmpty(widget.kanji["kanji_description"]);
    final onyomi =
        _valueOrEmpty(widget.kanji["on_pronunciation"] ?? widget.kanji["onyomi"]);
    final kunyomi =
        _valueOrEmpty(widget.kanji["kun_pronunciation"] ?? widget.kanji["kunyomi"]);
    final level = _valueOrEmpty(widget.kanji["jlpt"] ?? widget.kanji["level"]);
    final strokes = _valueOrEmpty(widget.kanji["num_strokes"]);
    final createdAt = _valueOrEmpty(widget.kanji["create_at"]);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kanji Detail"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kanjiChar,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (meaning.isNotEmpty) Text("Meaning: $meaning"),
            if (description.isNotEmpty) Text("Description: $description"),
            if (onyomi.isNotEmpty) Text("Onyomi: $onyomi"),
            if (kunyomi.isNotEmpty) Text("Kunyomi: $kunyomi"),
            if (level.isNotEmpty) Text("JLPT: $level"),
            if (strokes.isNotEmpty) Text("Strokes: $strokes"),
            if (createdAt.isNotEmpty) Text("Created: $createdAt"),
            const SizedBox(height: 16),
            const Text(
              "Stories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (isLoadingStories)
              const LinearProgressIndicator()
            else if (stories.isEmpty)
              const Text("No stories yet.")
            else
              Column(
                children: stories.map((story) {
                  final storyText = _valueOrEmpty(story["kanji_story"]);
                  final storyCreatedAt = _valueOrEmpty(story["create_at"]);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => FlashCardDialog(
                            title: "Kanji Story",
                            content: storyText.isEmpty ? "-" : storyText,
                          ),
                        );
                      },
                      title: Text(storyText.isEmpty ? "-" : storyText),
                      subtitle: storyCreatedAt.isEmpty
                          ? null
                          : Text("Created: $storyCreatedAt"),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
