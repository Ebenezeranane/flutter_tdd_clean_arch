import 'package:flutter_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';

import 'package:flutter_tdd_clean_arch/core/errors/failure.dart';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasource/number_trivia_local_data_source.dart';
import '../datasource/number_trivia_remote_data_source.dart';


typedef Future<NumberTrivia> _concreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  

  NumberTriviaRepositoryImpl(
      {this.localDataSource, this.remoteDataSource, this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _concreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDataTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteDataTrivia);
        return Right(remoteDataTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localDataTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localDataTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
