import 'package:crypton/crypton.dart' as crypton;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

class AppEncrypt {
  static final _key = encrypt.Key.fromSecureRandom(32);

  ///Global variable that holds the AES initializer.
  static final _iv = encrypt.IV.fromLength(16);

  ///Global variable used to help randomize the AES initializer with an Initialization Vector.
  static final _rsaKeyPair = crypton.RSAKeypair.fromRandom();

  ///Global variable that sets and stores a RSA key pair.
  static final _setRsaPub = _rsaKeyPair;

  ///Global variable meant to hold a single instance of the RSA key pairing. Important for For-loop

  ///returns the value of the global variable _key.
  get getKey {
    return _key;
  }

  ///returns the value of the global variable _iv.
  get getIV {
    return _iv;
  }

  ///returns the value of the variable _setRsaPub
  getRSAPubKey() {
    return _setRsaPub;
  }

  //Creates an instance the AES encryption/decryption Algorithm. Mostly used to share data between both encrypter/decrypt classes. Encrypter Data Type fund in the encrypt.dart package
  dynamic getAESEncryptInitializer(dynamic init, dynamic valToEncrypt, iv) {
    dynamic encrypted = init.encrypt(valToEncrypt, iv: iv);
    return encrypted;
  }

  dynamic getAESDecryptInitializer(dynamic init, dynamic valToEncrypt, iv) {
    dynamic decrypted = init.decrypt(valToEncrypt, iv: iv);
    return decrypted;
  }

  //Creates an initializer key for the AES encryption/decryption Algorithm. Encrypter Data Type fund in the encrypt.dart package.
  dynamic getAESInit(key) {
    final init =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cfb64));
    return init;
  }

  Future<Tuple3<String, String, String>> encryptReadWrite(String file) async {
    // var path = ReadWrite().userFile(setTakeUserPath(filePath));
    dynamic display;
    // var holdFileContent = await ReadWrite().testReading(path);
    //String holdFileContent = await IOHelper.readFile(file);
    //display = encryptAES(holdFileContent);
    // display = encryptAES(holdFileContent);
    display = encryptAES(file);
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
    //await ReadWrite().writeCounter(path, display3);
    // await IOHelper.writeFile(file, display3);
    if (kDebugMode) {
      print(display3.toString().length);
    }
    if (kDebugMode) {
      print(keyInst);
    }
    if (kDebugMode) {
      print(rsaPvtInst);
    }

    return Tuple3(display3, keyInst, rsaPvtInst);
  }

  Future<String> decryptReadWrite(
      String filePath, String aesKey, String rsaPvtKey) async {
    //var path = ReadWrite().userFile(setTakeUserPath(filePath));
    //var holdFileContent = await ReadWrite().testReading(path);
    //final holdFileLength = holdFileContent.toString().length;
    dynamic display = "";
    dynamic rsaSectorDecrypt = "";
    int y = 0;
    for (int i = 0; i <= filePath.length; i += 344) {
      if (filePath.length < 344) {
        display = decryptRSA(filePath, rsaPvtKey);
      } else if (y + 344 > filePath.length) {
        display = decryptRSA(filePath.substring(i, filePath.length), rsaPvtKey);
      } else {
        display = decryptRSA(filePath.substring(i, i + 344), rsaPvtKey);
      }
      rsaSectorDecrypt += "$display";
      display = "";
      y += 344;
    }
    dynamic display2 = decryptAES(rsaSectorDecrypt, aesKey);
    // await ReadWrite().writeCounter(
    //     path, "$display2");
    return display2;
  }

//File Path Setter
  dynamic setTakeUserPath(dynamic enterFileLocation) {
    return (enterFileLocation);
  }

//Encrypts the string to ECB_AES Encryption. Takes in a String value, and spits out an Integer.
  dynamic encryptAES(dynamic valToEncrypt) {
    var key = AppEncrypt().getKey;
    dynamic init = AppEncrypt().getAESInit(key);
    dynamic encrypted = AppEncrypt()
        .getAESEncryptInitializer(init, valToEncrypt, AppEncrypt().getIV);
    final cipherText = encrypted.base64;
    return cipherText;
  }

//Decrypts a String encrypted by RSA with a PKCS1 signing. Takes the String from the encrypt_RSA method and Decrypts it.
  dynamic decryptRSA(dynamic rsaEncrypt, final pvtKey) {
    final rsaPvtKey = crypton.RSAPrivateKey.fromString("$pvtKey");
    final decrypt = rsaPvtKey.decrypt(rsaEncrypt);
    return decrypt;
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
}

// main() async {
//   //await Reader_WriterEncrypt('/Users/levi/Library/CloudStorage/OneDrive-CaliforniaBaptistUniversity/Capstone_Current/cuddly_telegram/lib/encrypt/Testing.dart');
//   //await decryptReadWrite('/Users/levi/Library/CloudStorage/OneDrive-CaliforniaBaptistUniversity/Capstone_Current/cuddly_telegram/lib/encrypt/Testing.dart', 'M10s1UPEF74iAI2s3NfLZGLEq7ACAChrZzPuU4CKeQc=', 'MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCX2UUE2o+3ycK86D1L0WT06LIVLgKZLHDTxexeyLV+ueh7gLR8Zx3iU2Zv6xXIB/LCzne/uKxB0K8EG+iPFxWPszQx1Rt59+uvcNp3ORhw+O8tQ7C9EQfcHAVHcB3p5Y2E7W138KOREqLl9onTtkuVLwiaRNQiHkKcunni3qo0karEHawlxVoaOisocdytgT1NipjVKLd7WT6LlHY8xnPfAOlPg2HvoyCp/z9Kkxtbp7O4GX03ZTdqppW5tRHlz716be0poWFAKBhL6OgfKSrc3fI+KwEfSniKkaQ6QICDYEsK7cbJ2ODaE5xkNFPyTrHUh0TKXgW1TaiEGW6VPsj7AgMBAAECggEAbGcdUKO/KdONhFK/P5sS2YwtZdVc4YDKY0TOw7PBbeDGSTTOpGjw+pvTa16GRDD4a33+Gw55Wtrhtqs90LkIGXgzcMfUP7RvuuVz8Nz/x9bO2J+UUsUPuWD/m8o8cLgB2b2uAov2GSEWzdi8+DkRqETVfVxZnKnBoCW30fBnzfJ1gvdsj/WSpKGTpLWuCaNi771hWVwmnxkWiBwL5iaOgKpFJdOAQ+xgyju8q3ZHOh43Xiyg4stUPVCdeahpNuEaXMircZEP4WFI9hlL6RsqIM7lo0em8KTkv8/n8Y52cyAg/uO/GjOz5XpQvvrZvsh9B0uTm9u0G4GgWTHuHkDKcQKBgQD9GTj0WfzKwg0hz/4q4cC0Ynx79ILanF4c+2sPM3nSwsHt3ibEYWTZ+oATxvg2uesG2qpRgIlLStKrHLMXw7mzlW6ctEt77+LqH4P/ESOTI8puqGKQivI5xEeHeqMVRgZ8rrfwIqOU+Y8xr4TAAbVjz2QrvtBBgbCjMdKEfGEDnwKBgQCZlufUFpTFswyQ2H5ypR/4L1n3gGn6+DfY7MisX3csgx8BqH3GCeD36UlEwQlPBZO9F4tBvFRh1BgwM4CqISd2+rmw25w13ac1uk6vJpsbL8vJyUwymBwzrI7RC3CYMpRMUxnuyKLRXqDbjCobkF8yM/jDfgxAPSsfSSNA5kfdJQKBgQC7lrwt75x7s0QEcaKSqewoRm65eMqbuRXQKVB6Xc7HNW6DHQpit0UGgrH29pv2A+p8lAl0iu43jeeCx6y9ymWTAwiOwNrJq0zl9iHhJRTW88oQJmGXfER4KFBTy8Of+tzIAL94DlRsEGPfkZW0sg99QLOf8LduNe9zpXPAmmdVRQKBgG8vakYDztFLq9YTk35FAV62UKe2Y4JWPH+h8ieuuGQVy9V0dxBtSFnPnMXUBHwbKndh2uLMhj2Hv7btIcCHXb1pBhH8+RmZixl+9MUg6noE4L8EJVAfA5N44K5+XJUhUG/sXMKaphtxKHum/TiVDAUY0IYc8ptybIwqcwXhbratAoGBAOpeEYMGh3Jjc2wpdbrLmK1UxOTFGLpG6WGeIrWqgIW4it0QIDg3YZyMCv07iOuWCNz/Zc7x5m84P6d/2001RbBk7/uWQ/xLDcqq4SEUcaofr09lFaL1ZArGTuHR/CcimFFJ+ZamG63F1AjCVroAwn9TBhQIvybrrSfJNjXB62EK' );
// }
