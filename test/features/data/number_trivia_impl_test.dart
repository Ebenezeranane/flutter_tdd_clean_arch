import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_clean_arch/core/errors/exceptions.dart';
import 'package:flutter_tdd_clean_arch/core/errors/failure.dart';
import 'package:flutter_tdd_clean_arch/core/platform/network_info.dart';
import 'package:flutter_tdd_clean_arch/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_clean_arch/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_clean_arch/features/number_trivia/data/model/number_trivia_model.dart';
import 'package:flutter_tdd_clean_arch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;
  NumberTriviaRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', (){
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', ()  {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  //data for mocks and assertions
  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    //check for network connection
    test('check if the device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to the remote data source is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache data when the call to the remote data source is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the call to the remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return locally cached data when cached data is  present ',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);

        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return Cachefailure when cached data is  not present ',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getConcreteNumberTrivia(tNumber);

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });




  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number:121, text: 'test trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    //check for network connection
    test('check if the device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to the remote data source is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          'should cache data when the call to the remote data source is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repository.getRandomNumberTrivia();
        verify(mockRemoteDataSource.getRandomNumberTrivia());

        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return ServerFailure when the call to the remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);

        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test('should return locally cached data when cached data is  present ',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository.getRandomNumberTrivia();

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);

        expect(result, equals(Right(tNumberTrivia)));
      });

      test('should return Cachefailure when cached data is  not present ',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository.getRandomNumberTrivia();

        verify(mockLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockRemoteDataSource);

        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
