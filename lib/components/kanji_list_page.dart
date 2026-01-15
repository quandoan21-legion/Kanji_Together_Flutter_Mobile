import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KanjiListPage extends StatefulWidget {
  const KanjiListPage({super.key});

  @override
  State<KanjiListPage> createState() => _KanjiListPageState();
}

class _KanjiListPageState extends State<KanjiListPage> {
  List kanjiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKanji();
  }

  Future<void> fetchKanji() async {

    final response =[
        {
          "id": 1,
          "kanji": "会",
          "meaning": "cuộc họp; họp; hội nghị",
          "onyomi": "カイ エ",
          "kunyomi": "あ.う あ.わせる あつ.まる",
          "level": 70
        },
        {
          "id": 2,
          "kanji": "日",
          "meaning": "ngày; mặt trời",
          "onyomi": "ニチ ジツ",
          "kunyomi": "ひ び",
          "level": 1
        },
        {
          "id": 3,
          "kanji": "学",
          "meaning": "học",
          "onyomi": "ガク",
          "kunyomi": "まな.ぶ",
          "level": 5
        }
      ]
    ;

    setState(() {
      kanjiList = List.from(response);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kanji List"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: kanjiList.length,
        itemBuilder: (context, index) {
          final kanji = kanjiList[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                kanji["kanji"],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Meaning: ${kanji["meaning"]}"),
                  Text("Onyomi: ${kanji["onyomi"]}"),
                  Text("Kunyomi: ${kanji["kunyomi"]}"),
                  Text("Level: ${kanji["level"]}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
