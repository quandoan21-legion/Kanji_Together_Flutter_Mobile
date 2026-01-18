import 'package:flutter/material.dart';
import 'kanji_list_item.dart';

class KanjiListBody extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> kanjiList;

  const KanjiListBody({
    super.key,
    required this.isLoading,
    required this.kanjiList,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kanjiList.isEmpty) {
      return const Center(child: Text("No kanji found."));
    }

    return ListView.builder(
      itemCount: kanjiList.length,
      itemBuilder: (context, index) {
        final kanji = kanjiList[index] as Map<String, dynamic>;
        return KanjiListItem(kanji: kanji);
      },
    );
  }
}
