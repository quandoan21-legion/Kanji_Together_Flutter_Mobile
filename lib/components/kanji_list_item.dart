import 'package:flutter/material.dart';

class KanjiListItem extends StatelessWidget {
  final Map<String, dynamic> kanji;

  const KanjiListItem({super.key, required this.kanji});

  @override
  Widget build(BuildContext context) {
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
  }
}
