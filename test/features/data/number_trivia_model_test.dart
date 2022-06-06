import 'dart:convert';

import 'package:flutter_tdd_clean_arch/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:flutter_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final tnumberTriviaModel = NumberTriviaModel(text: 'Test Text', number: 1);
  test('test if NumberTrivia Model is a sub class of NumberTrivia entity',
      () async {
    expect(tnumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('Should return a valid model when the Json Number is an integer ',
        () async {
      //create a test with the fromJson method
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tnumberTriviaModel);
    });
  });

  group('toJson', () {
    test('Should return a JSON map containing the proper data ', () async {
      //create a test with the fromJson method

      final result = tnumberTriviaModel.toJson();

      final json = {'text': 'Test Text', 'number': 1};

      expect(result, json);
    });
  });
}
