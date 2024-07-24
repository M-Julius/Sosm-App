import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashHelper {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert to UTF8
    final digest = sha256.convert(bytes); // Hash using SHA-256
    return digest.toString();
  }
}
