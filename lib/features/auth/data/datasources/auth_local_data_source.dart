import '../../../../core/services/secure_storage/secure_storage_service.dart';

abstract interface class AuthLocalDataSource {
  Future<void> saveToken(String key, String value);
  Future<String?> getToken(String key);
  Future<void> deleteToken(String key);

  Future<void> saveUserId(String key, String value);
  Future<String?> getUserId(String key);
  Future<void> deleteUserId(String key);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorageService;

  AuthLocalDataSourceImpl({required SecureStorageService secureStorageService})
    : _secureStorageService = secureStorageService;

  @override
  Future<void> deleteToken(String key) async {
    await _secureStorageService.deleteString(key);
  }

  @override
  Future<String?> getToken(String key) async {
    return await _secureStorageService.getString(key);
  }

  @override
  Future<void> saveToken(String key, String value) async {
    await _secureStorageService.saveString(key, value);
  }

  @override
  Future<void> deleteUserId(String key) async {
    await _secureStorageService.deleteString(key);
  }

  @override
  Future<String?> getUserId(String key) async {
    return await _secureStorageService.getString(key);
  }

  @override
  Future<void> saveUserId(String key, String value) async {
    await _secureStorageService.saveString(key, value);
  }
}
