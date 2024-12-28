import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static final _storage = FlutterSecureStorage();

  // Retrieve or generate an encryption key securely
  static Future<String> _getEncryptionKey() async {
    String? key = await _storage.read(key: 'encryption_key');
    if (key == null) {
      key = encrypt.Key.fromLength(32).base64; // Generate a 256-bit key
      await _storage.write(key: 'encryption_key', value: key);
    }
    return key;
  }

  // Encrypt a plain text message
  static Future<String> encryptMessage(String plainText) async {
    final key = encrypt.Key.fromBase64(await _getEncryptionKey());
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  // Decrypt an encrypted message
  static Future<String> decryptMessage(String encryptedText) async {
    final key = encrypt.Key.fromBase64(await _getEncryptionKey());
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}
