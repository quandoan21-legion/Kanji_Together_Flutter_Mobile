import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KanjiListPage extends StatefulWidget {
  const KanjiListPage({super.key});

  @override
  State<KanjiListPage> createState() => _KanjiListPageState();
}

class _KanjiListPageState extends State<KanjiListPage> {
  List<dynamic> kanjiList = [];
  bool isLoading = true;

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
        // If your Postman mock requires it, add:
        // "x-api-key": "<YOUR_POSTMAN_MOCK_KEY>",
      });

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        // If API returns { status, message, data: [...] }
        final list = decoded is List ? decoded : (decoded["data"] ?? []);

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: kanjiList.length,
              itemBuilder: (context, index) {
                final kanji = kanjiList[index] as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      "${kanji["kanji"] ?? ""}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Meaning: ${kanji["meaning"] ?? kanji["translation"] ?? ""}"),
                        Text("Onyomi: ${kanji["onyomi"] ?? kanji["on_pronunciation"] ?? ""}"),
                        Text("Kunyomi: ${kanji["kunyomi"] ?? kanji["kun_pronunciation"] ?? ""}"),
                        Text("Level: ${kanji["level"] ?? kanji["jlpt"] ?? ""}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
