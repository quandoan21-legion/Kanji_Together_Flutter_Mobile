import 'package:flutter/material.dart';
import 'kanji_list_item.dart';

class KanjiListBody extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> kanjiList;
  final Map<int, int> storyCountByKanjiId;

  const KanjiListBody({
    super.key,
    required this.isLoading,
    required this.kanjiList,
    required this.storyCountByKanjiId,
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
        final id = kanji["id"];
        final kanjiId = id is int ? id : int.tryParse(id?.toString() ?? "");
        final storyCount = kanjiId == null ? 0 : (storyCountByKanjiId[kanjiId] ?? 0);
        return KanjiListItem(
          kanji: kanji,
          storyCount: storyCount,
        );
      },
    );
  }
}
