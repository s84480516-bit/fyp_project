import '../logger/logger_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LoggerService _appLogger = LoggerService(className: "Local Storage");

  // Store a string value
  Future<bool> setValue(String key, String value) async {
    _appLogger.info("Setting value for key: $key with value: $value");
    await _secureStorage.write(key: key, value: value);
    return true;
  }

  // Read a string value
  Future<dynamic> readValue(String key) async {
    _appLogger.info("Reading value for key: $key");
    return await _secureStorage.read(key: key);
  }

  // Store a bool value
  Future<bool> setBoolValue(String key, bool value) async {
    _appLogger.info("Setting bool value for key: $key with value: $value");
    await _secureStorage.write(key: key, value: value.toString());
    return true;
  }

  // Read a bool value
  Future<bool?> readBoolValue(String key) async {
    _appLogger.info("Reading bool value for key: $key");
    String? value = await _secureStorage.read(key: key);
    return value == null ? null : value.toLowerCase() == 'true';
  }

  // Delete a value
  Future<bool> deleteValue(String key) async {
    _appLogger.info("Deleting value for key: $key");
    await _secureStorage.delete(key: key);
    return true;
  }

  // Delete all data
  Future<bool> deleteAllData() async {
    _appLogger.info("Deleting all data from local storage");
    await _secureStorage.deleteAll();
    return true;
  }
}
