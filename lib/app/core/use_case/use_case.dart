abstract class AsyncUseCase<T,P>{
  Future<T> call(P params);
}

abstract class InputUseCase<T,P>{
  T call(P params);
}

abstract class UseCase<T>{
  T call();
}



class NoParams{}