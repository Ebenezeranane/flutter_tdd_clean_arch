import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tdd_clean_arch/core/errors/failure.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}


