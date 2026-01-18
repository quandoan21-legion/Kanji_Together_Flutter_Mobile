import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class KanjiPrimaryField extends StatelessWidget {
  final TextEditingController kanjiController;

  const KanjiPrimaryField({
    super.key,
    required this.kanjiController,
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
          title: "Chữ Kanji(*)",
          titleFontSize: 20,
          placeholder: "VD: 会",
          backgroundColor: const Color(0xffffffff),
          controller: kanjiController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
      ],
    );
  }
}

class KanjiOptionalFields extends StatelessWidget {
  final TextEditingController translationController;
  final TextEditingController levelController;
  final TextEditingController meaningController;
  final TextEditingController onyomiController;
  final TextEditingController kunyomiController;
  final TextEditingController numStrokesController;
  final TextEditingController writingImageUrlController;
  final TextEditingController radicalController;
  final TextEditingController componentsController;
  final TextEditingController kanjiDescriptionController;
  final TextEditingController vocabularyController;
  final TextEditingController examplesController;

  const KanjiOptionalFields({
    super.key,
    required this.translationController,
    required this.levelController,
    required this.meaningController,
    required this.onyomiController,
    required this.kunyomiController,
    required this.numStrokesController,
    required this.writingImageUrlController,
    required this.radicalController,
    required this.componentsController,
    required this.kanjiDescriptionController,
    required this.vocabularyController,
    required this.examplesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          title: "Hán Việt (UPPERCASE)*",
          titleFontSize: 20,
          placeholder: "VD: HỘI",
          backgroundColor: const Color(0xffffffff),
          controller: translationController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
        CustomTextField(
          title: "Cấp độ JLPT(*)",
          titleFontSize: 20,
          placeholder: "1-5",
          backgroundColor: const Color(0xffffffff),
          controller: levelController,
          borderRadius: 12,
          type: TextInputType.number,
        ),
        CustomTextField(
          title: "Nghĩa Tiếng Việt(*)",
          titleFontSize: 20,
          placeholder: "VD: cuộc họp; hội nghị",
          backgroundColor: const Color(0xffffffff),
          controller: meaningController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
        CustomTextField(
          title: "Onyomi (mỗi cách đọc 1 dòng*)",
          titleFontSize: 20,
          placeholder: "VD: カイ\nエ",
          backgroundColor: const Color(0xffffffff),
          controller: onyomiController,
          borderRadius: 12,
          type: TextInputType.multiline,
          maxLines: 3,
        ),
        CustomTextField(
          title: "Kunyomi (mỗi cách đọc 1 dòng*)",
          titleFontSize: 20,
          placeholder: "VD: あ.う\nあ.わせる\nあつ.まる",
          backgroundColor: const Color(0xffffffff),
          controller: kunyomiController,
          borderRadius: 12,
          type: TextInputType.multiline,
          maxLines: 3,
        ),
        CustomTextField(
          title: "Số nét(*)",
          titleFontSize: 20,
          placeholder: "VD: 6",
          backgroundColor: const Color(0xffffffff),
          controller: numStrokesController,
          borderRadius: 12,
          type: TextInputType.number,
        ),
        CustomTextField(
          title: "URL ảnh cách viết (GIF/SVG*)",
          titleFontSize: 20,
          placeholder: "https://example.com/kanji.gif",
          backgroundColor: const Color(0xffffffff),
          controller: writingImageUrlController,
          borderRadius: 12,
          type: TextInputType.url,
        ),
        CustomTextField(
          title: "Bộ thủ (Radical*)",
          titleFontSize: 20,
          placeholder: "VD: 日 NHẬT",
          backgroundColor: const Color(0xffffffff),
          controller: radicalController,
          borderRadius: 12,
          type: TextInputType.text,
        ),
        CustomTextField(
          title: "Bộ thành phần (mỗi dòng 1 bộ)",
          titleFontSize: 20,
          placeholder: "VD:\n日 Nhật\n寸 Thốn",
          backgroundColor: const Color(0xffffffff),
          controller: componentsController,
          borderRadius: 12,
          type: TextInputType.multiline,
          maxLines: 3,
        ),
        CustomTextField(
          title: "Câu chuyện ghi nhớ(*)",
          titleFontSize: 20,
          placeholder: "VD: câu chuyện giúp ghi nhớ kanji",
          backgroundColor: const Color(0xffffffff),
          controller: kanjiDescriptionController,
          borderRadius: 12,
          type: TextInputType.multiline,
          maxLines: 3,
        ),
        CustomTextField(
          title: "Từ vựng (mỗi dòng: JP-PHIÊN ÂM-NGHĨA)*",
          titleFontSize: 20,
          placeholder: "VD:\n日本-にほん-Nhật Bản",
          backgroundColor: const Color(0xffffffff),
          controller: vocabularyController,
          borderRadius: 12,
          type: TextInputType.multiline,
          maxLines: 4,
        ),
        CustomTextField(
          title: "Câu ví dụ (mỗi dòng: JP-VI)*",
          titleFontSize: 20,
          placeholder: "VD:\n今日は天気が良い-Weather is nice today",
          backgroundColor: const Color(0xffffffff),
          controller: examplesController,
          borderRadius: 12,
          type: TextInputType.multiline,
          maxLines: 4,
        ),
      ],
    );
  }
}
