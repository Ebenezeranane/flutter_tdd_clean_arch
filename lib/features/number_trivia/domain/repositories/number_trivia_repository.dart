// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_arch/core/errors/failure.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();

}
