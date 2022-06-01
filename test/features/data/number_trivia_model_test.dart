import 'package:flutter_tdd_clean_arch/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:flutter_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final numberTriviaModel = NumberTriviaModel(text: 'Testing', number: 1);
  test('test if NumberTrivia Model is a sub class of NumberTrivia entity',
      () async {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });
}
