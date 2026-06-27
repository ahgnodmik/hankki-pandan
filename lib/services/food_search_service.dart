import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../core/data/food_db.dart';
import '../models/food_models.dart';

// 공공데이터포털 식품영양성분 DB (FoodNtrCpntDbInfo02)
// 응답 단위: 1회 제공량(servingWt g) 기준 → per-100g으로 변환 후 저장
class FoodSearchService {
  static const _baseUrl =
      'https://apis.data.go.kr/1471000/FoodNtrCpntDbInfo02/getFoodNtrCpntDbInq02';

  List<FoodResult> searchLocal(String query) {
    final q = query.trim();
    if (q.isEmpty) return [];
    return localFoodDb.where((f) => f.name.contains(q)).toList();
  }

  Future<List<FoodResult>> searchApi(String query) async {
    final key = dotenv.env['FOOD_API_KEY'] ?? '';
    if (key.isEmpty || key == 'your_food_api_key_here') return [];

    try {
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'serviceKey': key,
        'pageNo': '1',
        'numOfRows': '10',
        'FOOD_NM_KR': query.trim(),
        'type': 'json',
      });

      final response =
          await http.get(uri).timeout(const Duration(seconds: 6));
      if (response.statusCode != 200) return [];

      final body = jsonDecode(utf8.decode(response.bodyBytes));

      // data.go.kr 공통 래퍼: response.body.items
      final rawItems = body['response']?['body']?['items'];
      if (rawItems == null) return [];

      // items 가 단일 객체일 때도 처리
      final List<dynamic> rows =
          rawItems is List ? rawItems : [rawItems];

      return rows
          .map((row) => _parseRow(row as Map<String, dynamic>))
          .whereType<FoodResult>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  FoodResult? _parseRow(Map<String, dynamic> row) {
    // 식품명 — camelCase
    final name = (row['foodNmKr'] as String? ?? '').trim();
    if (name.isEmpty) return null;

    // 1회 제공량(g)
    final serving =
        double.tryParse((row['servingWt'] ?? '100').toString().trim()) ??
            100.0;
    if (serving <= 0) return null;

    double v(String key) =>
        double.tryParse((row[key] ?? '0').toString().trim()) ?? 0.0;

    // nutrCont1=에너지(kcal), nutrCont3=단백질, nutrCont4=지방, nutrCont6=탄수화물
    // 값은 1회 제공량 기준 → per-100g 으로 환산
    final factor = 100.0 / serving;

    return FoodResult(
      name: name,
      kcalPer100g: v('nutrCont1') * factor,
      proteinPer100g: v('nutrCont3') * factor,
      fatPer100g: v('nutrCont4') * factor,
      carbsPer100g: v('nutrCont6') * factor,
      defaultServingG: serving.round(),
    );
  }
}
