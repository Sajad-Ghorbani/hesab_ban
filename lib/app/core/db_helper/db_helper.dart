abstract class DBHelper<T> {
  Future<void> save(T value);

  Future<void> update(T value);

  Future<void> delete(int id);

  T? getById(int id);

  List<T> getAll();
}
