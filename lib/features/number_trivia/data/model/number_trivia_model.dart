import 'package:flutter_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia {
  NumberTriviaModel({String text, int number})
      : super(text: text, number: number);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'],
      number: (json['number']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'number': number};
  }
}
