import 'package:flutter/material.dart';
import '../screens/kanji_detail_page.dart';

class KanjiListItem extends StatelessWidget {
  final Map<String, dynamic> kanji;
  final int storyCount;

  const KanjiListItem({
    super.key,
    required this.kanji,
    required this.storyCount,
  });

  @override
  Widget build(BuildContext context) {
    final jlptLevel = kanji["jlpt"] ?? kanji["level"] ?? "";
    return Card(
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => KanjiDetailPage(kanji: kanji),
                ),
              );
            },
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
                Text("Stories: $storyCount"),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Text(
                "JLPT $jlptLevel",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
