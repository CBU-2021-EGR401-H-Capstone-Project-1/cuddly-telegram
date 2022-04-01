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
  //await Reader_WriterEncrypt('/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/lib/Encryption/test.txt');
  //await readerWriterDecrypt('/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/lib/Encryption/test.txt');
}

Future<dynamic> readerWriterEncrypt(dynamic filePath) async {
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

Future<dynamic> readerWriterDecrypt(dynamic filePath) async {
  var path = ReadWrite().userFile(setTakeUserPath(filePath));
  var holdFileContent = await ReadWrite().testReading(path);
  final holdFileLength = holdFileContent.toString().length;
  dynamic display = "";
  dynamic rsaSectorDecrypt = "";
  int y = 0;
  for (int i = 0; i <= holdFileLength; i += 344) {
    if (holdFileLength < 344) {
      display = decryptRSA(holdFileContent);
    } else if (y + 344 > holdFileLength) {
      display =
          decryptRSA(holdFileContent.toString().substring(i, holdFileLength));
    } else {
      display = decryptRSA(holdFileContent.toString().substring(i, i + 344));
    }
    rsaSectorDecrypt += "$display";
    display = "";
    y += 344;
  }
  dynamic display2 = decryptAES(
      rsaSectorDecrypt, "/JWGTW1NXbi3Ch74VsoHUG9eyQE8AF4X7pQorwoc2PA=");
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
dynamic decryptRSA(dynamic rsaEncrypt) {
  final rsaPvtKey = crypton.RSAPrivateKey.fromString(
      "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2uTkrAdUVkaFFrHPZP6xO01HC929FcxBP74kZ8QcLy8pVOSAxxLdKFtr8b1r1Ea0A9ase+YgE3F66SBQ/CT7bGSabBHG47kQmz8VWoeytUwaZ/NeU4ybTjuE/a9KtfqL2ppjxmzMdA4UWoIF/GXCw6qolMPn9wxu/V2xHgderIp+c3kuS6C7GkHVpLxmPy7n6JcS7vyKBhpY/qoWF5+sDqGrOZ+6v/qAGsuTh1OGm7gj+LxQI2ctEhPvFpsYzgypV4VZ5iA3qHxXgLRwqlcH7dj5SG6j6hoxLpxwL4dO3tFRC6US9fX9aSt6Zf2YxSk8VKrPOzxNvzAcntCORRvgrAgMBAAECggEBAKv0tasWh1xL95RlDYT2mgZ4cipjxxB5j3FagBCsti/QsfHv169ebAtKZP1JIjUdVE1h5I86z1mbtX3jFUKZRdDU43LhBNC/Ud2gjBrSObSHPOAvhQX1mvVfMfUIWHSzh1NNRwOgRcLZLCc2F4fv/hBQVpy3cZvxQCyabikBNWAzlBqlu6bhveM5UBbgVWOz1FOPa8eZo5f7BXM9oLPwhPf/uKUMIqeZUuabH6l07Dx/gNJRaAaVwmMNXi43eGu82k/18oIJuNqPBzRLvB2owS/q0j/Wv9/7pFHZE/IiLQ5XVM7ITyq4odN3fderQ7ju+96u1jmZzF99oDrGnJUjFYkCgYEA9F25dOr58Siq0r+O7CJH7kULmW1pXdtZSnHwtQ2EfVvdMm99phTkE65ohTCK1SLQl7f37+jADKGh6iQodxG+nAkc8Ke12HJjgjCMrfVtVhxc5uyY5awTQHmD7DT57/1OO44zz53nt9/aF6h4b1JeosR9z5MYPjYWBNFWJiV4lJ8CgYEAv2w2v3eUoVb0fFIqsk+g04SBfT4VPCoXNT0kGpatAGEsbuWBZgYMhUfQ4Ql8qjcechWc41TjFlF/0o+xLbV4+EID+1O1+tL9A90sbkjtu+Zrw1B4bssWkgZ5Hg1uGsYU6Ru6D5pspZHv1N7zN6fOwE+VvSKZAFSHe+zAPeaJxPUCgYEAs/bmYzW+Fx3VGFpdHohsowyUa00JoUaursXU+PHYlh32fHNhfNO72MbEUPqb9DWsm1+wKC4oaeULgo1Yg8A8uVt4xb8tjBdKM5IfuOmbuSQwQx0RyWt9zijvwCCPxW+ukuu6OnfXNDKWwn+fGpT1/zdoVFvHKeHZO3kT0gockI8CgYAxGKc+GoSTkQLp9AUhcMz2E1FG9yppIP6M2B6vdx/uLf5AfzreGQUTFiVb4pwH6FU1u5des0H/Um3vao1uBNJ/EieFSaYuK/lbCVpA+xGGlQXktXn+KLakQ2bDL3yi/1UTqNni8J+XI8QYnApTpwWfS4pDVWFatVN+lG2GMt/5FQKBgCB3mAUPJBMCYkku2y0Ej525JnBb4ZMjdQBQkRn/VLHki9n4oHcPSlZcnrlIMFTBykE31lufS61qMdH/TTd0LveJrR0AkkJ7jdgIFENSOuJBXJKwKkTlK19nFEMJewdZAuJgE8tz66KhIaio9hLAPxsofPNRhY9x8ogYCbtY3b9o");
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
