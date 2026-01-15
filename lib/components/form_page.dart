import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final kanjiController = TextEditingController();
  final meaningController = TextEditingController();
  final onyomiController = TextEditingController();
  final kunyomiController = TextEditingController();
  final levelController = TextEditingController();

  Future<void> submitForm() async {
    final data = {
      "kanji": kanjiController.text,
      "on_pronunciation": onyomiController.text,
      "kun_pronunciation": kunyomiController.text,
      "num_strokes": 0,
      "jlpt": int.tryParse(levelController.text),
      "kanji_description": meaningController.text,
      "translation": meaningController.text,
      "is_active": true,
      "create_by": 1,
    };

    final response = await http.post(
      Uri.parse("https://b0cf4586ffec.ngrok-free.app/api/v1/kanji-characters"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data)
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("SUCCESS: ${response.body}");
    } else {
      print("FAILED: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              ElevatedButton(
                onPressed: submitForm,
                child: const Text("SUBMIT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
