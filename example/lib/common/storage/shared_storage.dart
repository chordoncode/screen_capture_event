import 'package:get_storage/get_storage.dart';
import 'package:grab_tags/common/storage/shared_storage_key.dart';

class SharedStorage {
  static SharedStorage _instance = SharedStorage._internal();
  static late GetStorage _storage;

  SharedStorage._internal() {
    _instance = this;
  }

  factory SharedStorage() => _instance;

  _init() async {
    await GetStorage.init().then((value){
      print(" GetStorage.init() ");
      _storage = GetStorage();
    });
  }

  Future<SharedStorage> init() async {
    await _init();
    return SharedStorage();
  }

  static Future<void> flush() {
    return _storage.erase();
  }

  static Future<void> write(SharedStorageKey key, dynamic value) {
    return _storage.write(key.name(), value);
  }

  static Future<void> delete(SharedStorageKey key) {
    return _storage.remove(key.name());
  }

  static List<Future<void>> truncate() {
    return SharedStorageKey.values.map((e) => delete(e)).toList();

  }

  static T? read<T>(SharedStorageKey key) {
    return _storage.read(key.name());
  }

  static T? readMapValue<T>(SharedStorageKey key, dynamic mapKey) {
    dynamic value = _storage.read(key.name());
    if (value == null) {
      return null;
    }

    if (!(value is Map)) {
      String type = value.runtimeType.toString();
      throw Exception("value($type) is not a MAP instance.");
    }
    return value[mapKey];
  }
}
