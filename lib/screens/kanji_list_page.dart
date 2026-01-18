import 'package:flutter/material.dart';
import '../services/kanji_api_service.dart';
import '../widgets/kanji_list_body.dart';

class KanjiListPage extends StatefulWidget {
  const KanjiListPage({super.key});

  @override
  State<KanjiListPage> createState() => _KanjiListPageState();
}

class _KanjiListPageState extends State<KanjiListPage> {
  List<dynamic> kanjiList = [];
  bool isLoading = true;

  final KanjiApiService _api = const KanjiApiService();
  final Map<int, int> _storyCountByKanjiId = {};

  @override
  void initState() {
    super.initState();
    fetchKanji();
  }

  Future<void> fetchKanji() async {
    setState(() => isLoading = true);

    try {
      final results = await Future.wait([
        _api.fetchKanjiList(),
        _api.fetchKanjiStories(),
      ]);
      final list = results[0];
      final stories = results[1];
      final Map<int, int> counts = {};
      for (final story in stories.whereType<Map<String, dynamic>>()) {
        final id = story["kanji_id"];
        final kanjiId = id is int ? id : int.tryParse(id?.toString() ?? "");
        if (kanjiId == null) continue;
        counts[kanjiId] = (counts[kanjiId] ?? 0) + 1;
      }
      setState(() {
        kanjiList = List<dynamic>.from(list);
        _storyCountByKanjiId
          ..clear()
          ..addAll(counts);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load kanji: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kanji List")),
      body: KanjiListBody(
        isLoading: isLoading,
        kanjiList: kanjiList,
        storyCountByKanjiId: _storyCountByKanjiId,
      ),
    );
  }
}
