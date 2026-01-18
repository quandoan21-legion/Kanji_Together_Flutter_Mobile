import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/kanji_list_body.dart';

class KanjiListPage extends StatefulWidget {
  const KanjiListPage({super.key});

  @override
  State<KanjiListPage> createState() => _KanjiListPageState();
}

class _KanjiListPageState extends State<KanjiListPage> {
  List<dynamic> kanjiList = [];
  bool isLoading = true;

  List<dynamic> _extractKanjiList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      final data = decoded["data"];
      if (data is List) return data;
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    fetchKanji();
  }

  Future<void> fetchKanji() async {
    setState(() => isLoading = true);

    final uri = Uri.parse(
      "https://b0cf4586ffec.ngrok-free.app/api/v1/kanji-characters",
    );

    try {
      final res = await http.get(uri, headers: {
        "Accept": "application/json",
        "ngrok-skip-browser-warning": "true",
        // If your Postman mock requires it, add:
        // "x-api-key": "<YOUR_POSTMAN_MOCK_KEY>",
      });

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        // If API returns { status, message, data: [...] }
        final list = _extractKanjiList(decoded);

        setState(() {
          kanjiList = List<dynamic>.from(list);
          isLoading = false;
        });
      } else {
        throw Exception("HTTP ${res.statusCode}: ${res.body}");
      }
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
