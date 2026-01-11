import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'components/custom_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final kanjiController = TextEditingController();
  final meaningController = TextEditingController();
  final onyomiController = TextEditingController();
  final kunyomiController = TextEditingController();
  final levelController = TextEditingController();

  Future<void> submitForm() async {
    final data = {
      "name": kanjiController.text,
      "email": meaningController.text,
      // "onyomi": onyomiController.text,
      // "kunyomi": kunyomiController.text,
      // "level": levelController.text,
    };

    final response = await http.post(
      Uri.parse("http://10.0.2.2:8080/api/students"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data)
    );

    if (response.statusCode == 201) {
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
