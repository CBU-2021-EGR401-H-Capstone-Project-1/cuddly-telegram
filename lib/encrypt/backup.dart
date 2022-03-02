// ignore_for_file: non_constant_identifier_names
import 'package:cuddly_telegram/encrypt/read_write.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypton/crypton.dart' as crypton;

class AppEncrypt {
  static final _Key = encrypt.Key.fromSecureRandom(32);
  static final _IV = encrypt.IV.fromLength(16);
  static final _RSAKeyPair = crypton.RSAKeypair.fromRandom();

  //Generates a random 32 Character key. This key will be used to initialize the the getAESInit method.
  get getKey {
    return _Key;
  }

  get getIV {
    return _IV;
  }

  //Generates an RSA private/public key pairing instance for the RSA and PKCS1 signing algorithm. RSAKeyPair datatype found in the crypton.dart package.
  getRSAKeyPairing() {
    return _RSAKeyPair;
  }

  //Creates an instance the AES encryption/decryption Algorithm. Mostly used to share data between both encrypter/decrypt classes. Encrypter Data Type fund in the encrypt.dart package
  dynamic getEncrypter(dynamic init, dynamic valToEncrypt, iv) {
    dynamic encrypted = init.encrypt(valToEncrypt, iv: iv);
    return encrypted;
  }

  dynamic getDecrypter(dynamic init, dynamic valToEncrypt, iv) {
    dynamic Decrypted = init.decrypt(valToEncrypt, iv: iv);
    return Decrypted;
  }

  //Creates an initializer key for the AES encryption/decryption Algorithm. Encrypter Data Type fund in the encrypt.dart package.
  dynamic getAESInit(key) {
    final init = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.ctr, padding: null));
    return init;
  }
}

main() async {
  //   var display = encrypt_AES("I FUCKING DID IT");
  //    var display2 = encrypt_RSA(display);
  //var display3 = decryptRSA("RVtOZV2OxdP/+AJigvQrQO5Z0pOsUgvUtDcDbtaSgts0QZWnuUtWtA0Nmh7NN+DkQocLzitb9dw9760TRoSXWUK5p91/H2stqxz9wUdpVMvLIfEzYnKnwsPOzJ6XUiryQO3odHF0FiG64DgFyjxoHzsStxE9XHvKTC4bC/1TvLMgwju3xeCHKbAuelI2ksSCxufDorOzp4di+Sywz8EtKYHbZ1FUFW1OazmZp8H6P3VGXPzngs2poTXOiNry9wpw1WK8u5b0HytV/yDVWHgnEJmElVWSH6GOcLYFHVXA4qGD5teOXv0aC1BWYnY89rVQo9PBO6vwIyGnyQ52ie1Jqg==");
  //var display4 = decryptAES("uOfSa/3b+2DKSyE4YwY0rcbZP0GCYbC0WE+eN15Z5g==", "A+KNPztmqMbBYAXMyYp2Z6BgY3cgBq4VBUIQrbJm70s=");
  // print(display);
  // print(display2);
  //print(display3);
  //print(display4);
  //await Reader_WriterEncrypt('/Users/levi/Library/CloudStorage/OneDrive-CaliforniaBaptistUniversity/Capstone/Capstone_AESRSA_Hybrid_JavaVersion/cuddly_telegram/lib/Encryption/test.txt');
  //await Reader_WriterDecrypt('/Users/ladmin/OneDrive - California Baptist University/Capstone/Capstone_AESRSA_Hybrid_JavaVersion/cuddly_telegram/lib/Encryption/test.txt');
}

Future<dynamic> Reader_WriterEncrypt(dynamic filePath) async {
  var path = ReadWrite().userFile(setTakeUserPath(filePath));
  dynamic display;
  dynamic display2;
  var holdFileContent = await ReadWrite().testReading(path);
  display = encrypt_AES(holdFileContent);
  display2 = encrypt_RSA(display);
  //var display3 = "$display2" + encrypt_RSA(display.toString().substring(245, 490));

  final keyInst = AppEncrypt().getKey.base64;
  final rsaPvtInst = AppEncrypt().getRSAKeyPairing().privateKey.toString();
  final rsaPubInst = AppEncrypt().getRSAKeyPairing().publicKey.toString();
  await ReadWrite().writeCounter(
      path,
      display +
          "\n$display2" +
          "\nAES_KEYinit: $keyInst" +
          "\nRSAPrivateKey: $rsaPvtInst" +
          "\nRSAPubKey: $rsaPubInst" +
          "\n length: ${display2.length}");
}

// Future<dynamic> Reader_WriterDecrypt(dynamic filePath) async {
//   var path = Read_Write().userFile(setTakeUserPath(filePath));
//   var holdFileContent = await Read_Write().testReading(path);
//   dynamic display = decryptRSA(holdFileContent);
//   dynamic display2 = decryptAES(display);
//   await Read_Write().writeCounter(path, display2);
// }

//File Path Setter
dynamic setTakeUserPath(dynamic enterFileLocation) {
  return (enterFileLocation);
}

//Encrypts the string to ECB_AES Encryption. Takes in a String value, and spits out an Integer.
dynamic encrypt_AES(dynamic valToEncrypt) {
  var key = AppEncrypt().getKey;
  dynamic init = AppEncrypt().getAESInit(key);
  dynamic encrypted =
      AppEncrypt().getEncrypter(init, valToEncrypt, AppEncrypt().getIV);
  final cipherText = encrypted.base64;
  return cipherText;
}

//Decrypts a String encrypted by RSA with a PKCS1 signing. Takes the String from the encrypt_RSA method and Decrypts it. Returns a Hash.

//Encrypts the hash from encrypt_AES. RSA PKCS1 signing can't encrypt anything higher than 2048 bits or 256 bytes. AES output must be converted to Hash. Dynamic method outputs a dynamic var that will hold a String.

dynamic encrypt_RSA(dynamic RSA_Encrypt) {
  dynamic Encrypt;
  Encrypt = AppEncrypt()
      .getRSAKeyPairing()
      .publicKey
      .encrypt(RSA_Encrypt.toString());
  return Encrypt;
}

//Decrypts the AES_ECB Encryption. It will take a String and output a String.
dynamic decryptAES(dynamic encrypted, var decryptKey) {
  var iv = AppEncrypt().getIV;
  //dynamic init = App_Encrypt().getAESInit(key);
  var key1 = encrypt.Key.fromBase64(
      decryptKey); // THIS LINE IS IMPORTANT FOR AES DECRYPTION OF A FILE!!!!!!!!!!!!
  dynamic init = AppEncrypt().getAESInit(key1);
  dynamic decrypt = init.decrypt64(encrypted, iv: iv);
  return decrypt;
}

//Initialization Vector, used to seed the AES_ECB algorithm.
dynamic decryptRSA(dynamic RSA_Encrypt) {
  //final rsaPvtKey = crypton.RSAPrivateKey.fromString("MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCptgQqOYGoTR5go3L6r/msOUNUmuhvIqBg7mWtmR+bTVTeUH468OHKWeSAmYnoTjy+gASewt0/WFvmrpikkoYReg7BLJvus/OakJJE0XjZtB3VudlTMOmCsVeT4pSHOPyhvLXeL8/E2grt8UNN4r+miL4hRwmtdYSMPgUp/OInEImnjxlV7cQ/CSlFc14LbkOFEMiAMlk5jGc7fmGdVo8Z/kyAbvyZyI/+jhZbqvzRhIIGxUZTuXjUfwcseibfTd9T4msSDfpS8A0BWr1U+db+VulviFo1ZIQebU8KKsK5EqABVAicF6CR10yBIDHDfQ0nRnIkdIs3K5NmGCwkWnPhAgMBAAECggEAZWwPpSRk5i3gX6SOzF5qeZBnOqKxEenBquwN++csymU2uP2l0peueH2sX2Zi0mAfUUG0gSS3kGm/0ma5dnDSipNFShDcx5TnmpGXuGTvMjvAMMA2rs7mXmKZkhmw5fcak5Xxom00X9JnAbhTnrJKEr5Z0g1gLTe0FRPjhipJBUqVqKDCcrBo45AFlnoRI0VZvG46flu51K+cV2gRec5dnqZGvjc8PWvXAnwj6AemwFrcH4bC5XJxvhQrJrHI38USNSAEWaXsJd9Gjhiz9D7q/HMVVTHMEiLPG5qVlJucQzzrEKg4maGBoUEAXAl336yQk43BzmNSpcAeiDbfqeth+QKBgQDU6H8VXSN/k/5OaL7USgL8NfMjD7aO3Lkd9HjJcgGsY46yaUo/Wn5C0nC5VUnE91GszV2fmiPjFyuz8udtr3XVVyI2M5DtYgMZeRCx891t/nXVdMXk0uHHjySmPag7N6d0eueLhAQ0bDHiITH891xoKHOfmf9+xWHgQx+xfwcBBwKBgQDMD1NK/6khzcUvCHlz4FvOn+QzCZ03PcTBgyB3QNz2LyK2i9D3oAAjUy5a60vaPVtDYlr+iC/6KNkP/LAnDTcM8L+siZtGkPoMFjW3XmznJ2WpUZSGvuArzfSpEMsM2mwH5F4t1ghXfMiispblKjiQz4MBawlWRXQtXOYm8zfx1wKBgEDr5FSPYhO0/QbLyeTR7LcbfFhkojZN9+S6d1p1+Syn7wtYL9vBrF6T7OuWpjf5cl5PAQ154xeMKTdmCkvYBQZY24XLk5XPHULXN9ALnKm9vhCo2u87nr1LWNGYW4QzJEzQbWqNhvq1Q0DA/o00oGjibN9uBgqSBZZs4W0uXuRhAoGActQg6/BILaSMVHYxWhqjrvdcw7eiR6azpK10RIc0kDhgEVdGZUIdMcOqLzF/QrUKOTYMvHTIgr4fv5ZTTfZqxxZm1eGthh0pCEorOh+hqsYJuCkXKmgY362LAuRXTslOx3Yj5SkvEoQ+pwdWUGjc4ehT8SVZYLm+sZQ4UyzEi4sCgYAXxwAZhffHE9Ul+J52AzC5GvCQaHRR/m2tspFl6FFisRJ7w84xSZcDs8zJMJiBvBJKgxowQzOKna0D+6vZZ0a1mGmaOkMOzWn4ZPcoamUdti3nQosJ79aPG7p7+rnzyd89NKZeGJ95pmyyiqcB9tHLtV2tJSf0+gJXLkLLZIbsmA==");
  // final Decrypt = rsaPvtKey.decrypt(RSA_Encrypt);
  final Decrypt =
      AppEncrypt().getRSAKeyPairing().privateKey.decrypt(RSA_Encrypt);
  return Decrypt;
}
