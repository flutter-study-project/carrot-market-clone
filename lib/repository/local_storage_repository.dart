import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
// Create storage
  final storage = new FlutterSecureStorage();

  Future<String?> getStoredValue(String key) async {
    try {
      return await storage.read(key: key);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> storeValue(String key, String value) async {
    try {
      return await storage.write(key: key, value: value);
    } catch (error) {
      print(error);
      return null;
    }
  }
}
