import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class KanjiFormFields extends StatelessWidget {
  final TextEditingController kanjiController;
  final TextEditingController meaningController;
  final TextEditingController onyomiController;
  final TextEditingController kunyomiController;
  final TextEditingController levelController;

  const KanjiFormFields({
    super.key,
    required this.kanjiController,
    required this.meaningController,
    required this.onyomiController,
    required this.kunyomiController,
    required this.levelController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Create Kanji",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        CustomTextField(
          title: "Kanji",
          titleFontSize: 20,
          placeholder: "会",
          backgroundColor: const Color(0xffffffff),
          controller: kanjiController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
        CustomTextField(
          title: "Ý Nghĩa",
          titleFontSize: 20,
          placeholder: "cuộc họp; họp; hội nghị",
          backgroundColor: const Color(0xffffffff),
          controller: meaningController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
        CustomTextField(
          title: "Âm On",
          titleFontSize: 20,
          placeholder: "カイ    エ",
          backgroundColor: const Color(0xffffffff),
          controller: onyomiController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
        CustomTextField(
          title: "Âm Kun",
          titleFontSize: 20,
          placeholder: "あ.う    あ.わせる    あつ.まる",
          backgroundColor: const Color(0xffffffff),
          controller: kunyomiController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
        CustomTextField(
          title: "Level",
          titleFontSize: 20,
          placeholder: "Level 70",
          backgroundColor: const Color(0xffffffff),
          controller: levelController,
          borderRadius: 12,
          type: TextInputType.number,
        ),
      ],
    );
  }
}
