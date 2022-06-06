import 'package:flutter_tdd_clean_arch/features/number_trivia/data/model/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Throws [NoLocalDataException] if no cached data is present.

  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
