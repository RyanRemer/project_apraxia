import 'package:encrypt/encrypt.dart';

class Encryption {

}


void main() {
  final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  print(encrypted.base64);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  print(decrypted);

}