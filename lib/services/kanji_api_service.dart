import 'dart:convert';
import 'package:http/http.dart' as http;

class KanjiApiService {
  static const String defaultBaseUrl = "https://454fbe6db3b4.ngrok-free.app";
  final String baseUrl;

  const KanjiApiService({this.baseUrl = defaultBaseUrl});

  Future<List<dynamic>> fetchKanjiList() async {
    final uri = Uri.parse("$baseUrl/api/v1/kanjis");
    final res = await http.get(uri, headers: {
      "Accept": "application/json",
      "ngrok-skip-browser-warning": "true",
    });

    if (res.statusCode != 200) {
      throw Exception("HTTP ${res.statusCode}: ${res.body}");
    }

    final decoded = jsonDecode(res.body);
    return _extractKanjiList(decoded);
  }

  Future<int> createKanjiCharacter(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/user/kanjis"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final id = _parseKanjiId(response.body);
      if (id != null) return id;
      throw Exception("Missing kanji id in response.");
    }
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }

  Future<void> submitStory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/kanji-stories"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    }
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }

  Future<int> createKanjiStory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/kanji-stories"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final id = _parseIdFromData(decoded);
      if (id != null) return id;
      throw Exception("Missing story id in response.");
    }
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }

  Future<void> updateKanjiStory(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse("$baseUrl/api/v1/kanji-stories/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return;
    }
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }

  Future<void> deleteKanjiStory(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/api/v1/kanji-stories/$id"),
    );

    if (response.statusCode == 200) {
      return;
    }
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }

  Future<List<dynamic>> fetchKanjiStories() async {
    final uri = Uri.parse("$baseUrl/api/v1/kanji-stories");
    final res = await http.get(uri, headers: {
      "Accept": "application/json",
      "ngrok-skip-browser-warning": "true",
    });

    if (res.statusCode != 200) {
      throw Exception("HTTP ${res.statusCode}: ${res.body}");
    }

    final decoded = jsonDecode(res.body);
    return _extractKanjiList(decoded);
  }

  Future<String> generateAiStory(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/v1/ai-kanji/generate"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final story = (decoded["data"]?["story"] ?? "").toString();
      if (story.isEmpty) {
        throw Exception("Empty story returned.");
      }
      return story;
    }
    throw Exception("HTTP ${response.statusCode}: ${response.body}");
  }

  List<dynamic> _extractKanjiList(dynamic decoded) {
    if (decoded is List) return decoded;
    if (decoded is Map<String, dynamic>) {
      final data = decoded["data"];
      if (data is List) return data;
    }
    return [];
  }

  int? _parseKanjiId(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final data = decoded["data"];
        if (data is Map<String, dynamic>) {
          final id = data["id"];
          if (id is int) return id;
          return int.tryParse(id?.toString() ?? "");
        }
        if (data is int) return data;
        final id = decoded["id"];
        if (id is int) return id;
        return int.tryParse(id?.toString() ?? "");
      }
    } catch (_) {}
    return null;
  }

  int? _parseIdFromData(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final data = decoded["data"];
      if (data is Map<String, dynamic>) {
        final id = data["id"];
        if (id is int) return id;
        return int.tryParse(id?.toString() ?? "");
      }
      if (data is int) return data;
    }
    return null;
  }
}
