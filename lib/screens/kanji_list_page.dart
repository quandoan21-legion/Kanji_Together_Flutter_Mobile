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

  @override
  void initState() {
    super.initState();
    fetchKanji();
  }

  Future<void> fetchKanji() async {
    setState(() => isLoading = true);

    try {
      final list = await _api.fetchKanjiList();
      setState(() {
        kanjiList = List<dynamic>.from(list);
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
      ),
    );
  }
}
