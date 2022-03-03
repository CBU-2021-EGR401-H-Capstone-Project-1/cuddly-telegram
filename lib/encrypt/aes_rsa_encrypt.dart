import 'package:cuddly_telegram/encrypt/read_write.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypton/crypton.dart' as crypton;

class AppEncrypt {
  static final _key = encrypt.Key.fromSecureRandom(32);
  static final _iv = encrypt.IV.fromLength(16);
  static final _rsaKeyPair = crypton.RSAKeypair.fromRandom();
  static final _setRsaPub = _rsaKeyPair;
  //Generates a random 32 Character key. This key will be used to initialize the the getAESInit method.
  get getKey {
    return _key;
  }

  get getIV {
    return _iv;
  }

  //Generates an RSA private/public key pairing instance for the RSA and PKCS1 signing algorithm. RSAKeyPair datatype found in the crypton.dart package.
  getRSAPubKey() {
    return _setRsaPub;
  }

  //Creates an instance the AES encryption/decryption Algorithm. Mostly used to share data between both encrypter/decrypt classes. Encrypter Data Type fund in the encrypt.dart package
  dynamic getEncrypter(dynamic init, dynamic valToEncrypt, iv) {
    dynamic encrypted = init.encrypt(valToEncrypt, iv: iv);
    return encrypted;
  }

  dynamic getDecrypter(dynamic init, dynamic valToEncrypt, iv) {
    dynamic decrypted = init.decrypt(valToEncrypt, iv: iv);
    return decrypted;
  }

  //Creates an initializer key for the AES encryption/decryption Algorithm. Encrypter Data Type fund in the encrypt.dart package.
  dynamic getAESInit(key) {
    final init =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cfb64));
    return init;
  }
}

main() async {
  //await Reader_WriterEncrypt('/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/cuddly_telegram/lib/encrypt/Testing.dart');
  await Reader_WriterDecrypt('/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/cuddly_telegram/lib/encrypt/Testing.dart', 'MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDXwVlvSvzKfg/F6Sq9eRBzn2E3+HUHV5EwiC5bIffVzlM40i0i1G/hheLktTXXeJ1ExnyDzAhWptPjGqfCj49VZKyO6Fv+R3SCdpQAO9K+PhxU6mMDn7k2Xd0zOghl4aR00YX/zKaOT26smXo49KNqBkFT3gLSuA6zDkWeXFQkC8BqbUrBOnS2Uo/mFocov6kZ/fxRgSziaXObxxX5XUAjYFjE139bW0cQOZcz1bTuIdu9rMDpinYVnwwgMsOOnpie/IEqF9QmGLuIpqkoRtEoBzzvKm8oxxqS53OL9Rx+GscgsiFLnKI0Kj3Mfh/s2W/fqeJx7GMGdCjT/lXXcvqNAgMBAAECggEBAIAeg8JP8D86jplCtauf6YIPYca/1pbOjBwashRR3n7rL4YtYLovFmUAgVS4uslCCXnet+/3x/fUxzw0BuzFHSNjTgjquD4OJoSWb5qX67Qm4+IU8UkknvJG2OTjkDsXu/XWudDFsR4O0zTRSr/pneSG5GIuEtUYkToIvpSkVR61d+GoJPupuGfUOj9UziDWHV/INyhbvTO9g/TIT6ilYLSBV0nST4BA1OgL05tPYoS4T66TBG31KWLZfI+DQf7m0u8ele8qtxNeNaFOqVXMvYIrfoknJqGhyKmv0T+05kfZ5duIwAAngX4+0DQEGxYsMh98c1aVRnGaSbBkqQavjMECgYEA/RfZ7EQfCP2t73kxTJ1g9GLEGSrHLYB6EHGAiLKeT6/3gyv0tdlYZO5n4xwn79aOzsKmc6B4ysrQeWzSx2Fwv4C32xZpYPOCXWodtB4jvLiSqAX+qZ9luyYyDKy5JMs0uYrdqkpoYIx59jzjKHVmWt+GyndCRgAGvNgCbQ+Af5ECgYEA2ju3ch54S+tKUL27voDlYMXzW3eydJTZ+kZ8wKUg02BaOcs2BIroxGgOKJVNBTHru+msbo0RzhO/wae57/CudSoSiwDHPcNc6h4csMg8sxLPNBwbd0dEiExBczc1dJDlL8nfNBEKdiZhfZuWrwN4GxL/0rLIE5K7yOpObcgKxT0CgYEA5uomCCy27CsX0RAP7MkCNrcOF7Ax/c/kjrAgB5iAXFA+UU1/fZMJ1Ty3SDzeKzLlJLvvxjs5Oj0FLGQfg43hore8B4ZRKwXBgZ1Z8IY3MO5t0CN4ECbAWJomu+2zFmDYgBi02bP9u2kvtXwj/Tvv4SVkA8H/k4Jeo1mqDPtB0CECgYADXdZ3oTaz3R5ZXoPt7WkcdBFMAO201LMEJGA6TJHUEPFzYMolicsLdJt7TspQYTPEw1cQoYZ7ylwz7ZV1uR3H2u1MTafFMSVWyz4gEAa3sHuXzzMxRN0uyRZdY6WkdbPDZ/bUg8rIhdENMgBCFOieak2d/3oMqz/QWqT5FpPr9QKBgQCAr4LYoOKCdigdb8QyiSD2C9soZZMEPIYs0MOfQT7FYlO+3tBrJbVzdcOPWM/G+HbThpr1b+7BqY4EM6vCt2SjFTcK0VR0lQxXv8PYukk720lhtvRIqYzH7lUiSpfFPqVCCT90RuPYKbFmVT7/YSdtcgZqIcJrDAVCywPI4fnPgA==', 'KmjbAFfddhIo8i7MtQJxrn2PS/FX0PFrE1h4GjFk0jI=');
}

Future<dynamic> Reader_WriterEncrypt(dynamic filePath) async {
  var path = ReadWrite().userFile(setTakeUserPath(filePath));
  dynamic display;
  var holdFileContent = await ReadWrite().testReading(path);
  display = encryptAES(holdFileContent);
  String display3 = "";
  String display2 = "";
  int y = 0;
  final passedInput = display.toString().length;
  for (int i = 0; i <= passedInput; i += 244) {
    if (passedInput < 244) {
      display2 = encryptRsa(display.toString().substring(i, passedInput));
    } else if (y + 244 > passedInput) {
      display2 = encryptRsa(display.toString().substring(i, passedInput));
    } else {
      display2 = encryptRsa(display.toString().substring(i, i + 244));
    }
    display3 += display2;
    display2 = "";
    y += 244;
  }
  final keyInst = AppEncrypt().getKey.base64;
  final rsaPvtInst = AppEncrypt().getRSAPubKey().privateKey.toString();
  await ReadWrite().writeCounter(path, display3);
  print(display3.toString().length);
  print(keyInst);
  print(rsaPvtInst);
}

Future<dynamic> Reader_WriterDecrypt(dynamic filePath, final rsaPvtKey, final aesKey) async {
  var path = ReadWrite().userFile(setTakeUserPath(filePath));
  var holdFileContent = await ReadWrite().testReading(path);
  final holdFileLength = holdFileContent.toString().length;
  dynamic display = "";
  dynamic rsaSectorDecrypt = "";
  int y = 0;
  for (int i = 0; i <= holdFileLength; i += 344) {
    if (holdFileLength < 344) {
      display = decryptRSA(holdFileContent, rsaPvtKey);
    } else if (y + 344 > holdFileLength) {
      display =
          decryptRSA(holdFileContent.toString().substring(i, holdFileLength), rsaPvtKey);
    } else {
      display = decryptRSA(holdFileContent.toString().substring(i, i + 344), rsaPvtKey);
    }
    rsaSectorDecrypt += "$display";
    display = "";
    y += 344;
  }
  dynamic display2 = decryptAES(rsaSectorDecrypt, "$aesKey");
  await ReadWrite().writeCounter(path, "$display2");
}

//File Path Setter
dynamic setTakeUserPath(dynamic enterFileLocation) {
  return (enterFileLocation);
}

//Encrypts the string to ECB_AES Encryption. Takes in a String value, and spits out an Integer.
dynamic encryptAES(dynamic valToEncrypt) {
  var key = AppEncrypt().getKey;
  // var iv = AppEncrypt().getIV; unused
  dynamic init = AppEncrypt().getAESInit(key);
  dynamic encrypted =
      AppEncrypt().getEncrypter(init, valToEncrypt, AppEncrypt().getIV);
  final cipherText = encrypted.base64;
  return cipherText;
}

//Decrypts a String encrypted by RSA with a PKCS1 signing. Takes the String from the encrypt_RSA method and Decrypts it.
dynamic decryptRSA(dynamic rsaEncrypt, final pvtKey) {
  final rsaPvtKey = crypton.RSAPrivateKey.fromString("$pvtKey");
  final decrypt = rsaPvtKey.decrypt(rsaEncrypt);
  return decrypt;
  //RSA Decryption of file is working!!!
}

//Encrypts the hash from encrypt_AES. RSA PKCS1 signing can't encrypt anything higher than 2048 bits or 256 bytes. Dynamic method outputs a dynamic var that will hold a String.
dynamic encryptRsa(dynamic rsaEncrypt) {
  var setPubKey = AppEncrypt().getRSAPubKey();
  var getPubKey = setPubKey.publicKey.encrypt(rsaEncrypt.toString());
  return getPubKey;
}

//Decrypts the AES_ECB Encryption. It will take a String and output a String.
dynamic decryptAES(dynamic encrypted, var decryptKey) {
  var iv = AppEncrypt().getIV;
  var key1 = encrypt.Key.fromBase64(
      decryptKey); // THIS LINE IS IMPORTANT FOR AES DECRYPTION OF A FILE!!!!!!!!!!!!
  dynamic init = AppEncrypt().getAESInit(key1);
  dynamic decrypt = init.decrypt64(encrypted, iv: iv);
  return decrypt;

  //AES Decryption of a file is working!!!!!
}
