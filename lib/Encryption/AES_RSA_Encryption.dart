// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:archive/archive.dart' as GZIP;
import 'package:cuddly_telegram/Encryption/Read_Write.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypton/crypton.dart' as crypton;
class App_Encrypt {


  static final _Key = encrypt.Key.fromSecureRandom(32);
  static final _IV = encrypt.IV.fromLength(16);
  static final _RSAKeyPair = crypton.RSAKeypair.fromRandom();
  static final _SetRsaPub = _RSAKeyPair;
  //Generates a random 32 Character key. This key will be used to initialize the the getAESInit method.
  get getKey {
    return _Key;
  }

  get getIV {
    return _IV;
  }

  //Generates an RSA private/public key pairing instance for the RSA and PKCS1 signing algorithm. RSAKeyPair datatype found in the crypton.dart package.
  getRSAPubKey() {
    return _SetRsaPub;
  }


  //Creates an instance the AES encryption/decryption Algorithm. Mostly used to share data between both encrypter/decrypt classes. Encrypter Data Type fund in the encrypt.dart package
  dynamic getEncrypter(dynamic init, dynamic valToEncrypt,
      iv) {
    dynamic encrypted = init.encrypt(valToEncrypt, iv: iv);
    return encrypted;
  }

  dynamic getDecrypter(dynamic init, dynamic valToEncrypt,
      iv) {
    dynamic Decrypted = init.decrypt(valToEncrypt, iv: iv);
    return Decrypted;
  }

  //Creates an initializer key for the AES encryption/decryption Algorithm. Encrypter Data Type fund in the encrypt.dart package.
  dynamic getAESInit(key) {
    final init = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cfb64));
    return init;
  }

}

main() async {
  //   var display = encrypt_AES("I FUCKING DID IT");
  //    var display2 = encrypt_RSA(display);
      //var display3 = decryptRSA("K6vdyDfg7YiPxH2DsxDhc1ziaX8X9YDTUnjBzhvczyayEshdrKF/gF232PgzxCz4Wcpo9V60WsG+zw8DtxO0xwLlo1t6vSMQ3uKaIeJ/tYXQu/TGbP8ajNcAWoPoEQtbdBkM+d6pLM/yitXfi0yA2Atrr0T7OzVE9S4crC5GH7j8IGWd6NcK+2Jm/c1af0tuDhSIkHSNaduR+FWLnKfruMO+dc8U9Cc86zUzgNvCjfC3QXWPg4kR9TRsR5c72X2sBlBmwafdSXCzabF82LAnUkn8kIwxyhkcIgOisdiVkNdQfB9yYx+oXmkf0+byfkfzTqDNbAppji6/4Tign0eqzQ==");
      //var display4 = decryptAES(display3, "9F112E67HuO2w2PXoXygMvPNAwtFeUNIulJkVjhU8AM=");
  // print(display);
  // print(display2);
    //print(display3);
    //print(display4);
  //await Reader_WriterEncrypt('/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/lib/Encryption/test.txt');
  await Reader_WriterDecrypt('/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/lib/Encryption/test.txt');
}

Future<dynamic> Reader_WriterEncrypt(dynamic filePath) async {
  var path = Read_Write().userFile(setTakeUserPath(filePath));
  dynamic display;
  var holdFileContent = await Read_Write().testReading(path);
  display = encrypt_AES(holdFileContent);
  String display3 = "";
  String display2 = "";
  int y = 0;
  final passedInput = display.toString().length;
  for(int i = 0; i <= passedInput; i+=244 ){
    if(passedInput < 244){
      display2 = encrypt_RSA(display.toString().substring(i, passedInput));
    }
    else if(y+244 > passedInput){
      display2 = encrypt_RSA(display.toString().substring(i, passedInput));
    } else {
      display2 = encrypt_RSA(display.toString().substring(i, i + 244));
    }
    display3 += "$display2";
    display2 = "";
    y += 244;
  }
  final keyInst = App_Encrypt().getKey.base64;
  final rsaPvtInst = App_Encrypt().getRSAPubKey().privateKey.toString();
  final rsaPubInst = App_Encrypt().getRSAPubKey().publicKey.toString();

  //Compressing String so that It doesn't break File limit:
  // var stringBytes = utf8.encode(display3);
  // var gzipBytes = GZIP.GZipEncoder().encode(stringBytes);
  // var compressedString = base64.encode(gzipBytes!);
  //Done Compressing String
  await Read_Write().writeCounter(path, display3);
  print(display3.toString().length);
  print(keyInst);
  print(rsaPvtInst);
  print(App_Encrypt._SetRsaPub.publicKey.toString());
  print(App_Encrypt._SetRsaPub.publicKey.toString());
  print(rsaPubInst);
  print(rsaPubInst);

}


Future<dynamic> Reader_WriterDecrypt(dynamic filePath) async {
  var path = Read_Write().userFile(setTakeUserPath(filePath));
  var holdFileContent = await Read_Write().testReading(path);
  // var decodeCompression = base64.decode(holdFileContent);
  // var unZip = GZIP.GZipDecoder().decodeBytes(decodeCompression);
  // String utf8Decode = utf8.decode(unZip);
  // final holdFileLength = utf8Decode.toString().length;
   final holdFileLength = holdFileContent.toString().length;
  dynamic display = "";
  dynamic rsa_SectorDecrypt = "";
  int y = 0;
  for(int i = 0; i <= holdFileLength; i+=344){
    if(holdFileLength < 344){
      //display = decryptRSA(utf8Decode);
      display = decryptRSA(holdFileContent);
    }
    else if(y+344 > holdFileLength){
      display = decryptRSA(holdFileContent.toString().substring(i, holdFileLength));
      //display = decryptRSA(utf8Decode.toString().substring(i, holdFileLength));
    } else {
      display = decryptRSA(holdFileContent.toString().substring(i, i+344));
      //display = decryptRSA(utf8Decode.toString().substring(i, i+244));
   }
    rsa_SectorDecrypt += "$display";
    display = "";
    y+=344;
  }
  dynamic display2 = decryptAES(rsa_SectorDecrypt, "/JWGTW1NXbi3Ch74VsoHUG9eyQE8AF4X7pQorwoc2PA=");
  //dynamic display2 = decryptAES(display, App_Encrypt().getKey);
  await Read_Write().writeCounter(path, "$display2");
}

//File Path Setter
dynamic setTakeUserPath(dynamic enterFileLocation) {
  return (enterFileLocation);
}

//Encrypts the string to ECB_AES Encryption. Takes in a String value, and spits out an Integer.
dynamic encrypt_AES(dynamic valToEncrypt) {
  var key = App_Encrypt().getKey;
   var iv = App_Encrypt().getIV;
  dynamic init = App_Encrypt().getAESInit(key);
  dynamic encrypted = App_Encrypt().getEncrypter(init, valToEncrypt, App_Encrypt().getIV);
  final cipherText = encrypted.base64;
  return cipherText;
}

//Decrypts a String encrypted by RSA with a PKCS1 signing. Takes the String from the encrypt_RSA method and Decrypts it.
dynamic decryptRSA(dynamic RSA_Encrypt){
  //dynamic holdFileContent = await Read_Write().testReading("/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/lib/Encryption/holdKey.txt");
  //dynamic text = holdFileContent;
  //final rsaPvtKey = crypton.RSAPrivateKey.fromString(text.toString("MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCKaQA3D1W/FwtNNQ6+tffWtaQGb5CtGd/K1RD70RPz61PdhU5VVYVsXYuKh2jzrIg79yugp7Fr8gcXE/L6kyIGGE3k/OIG/JSsq8KECMRA3CrdM0uwdWnqEpNF+/jPuch+pAsuty4OgYcOe/0PUt7P1a1jxNVEZjyjf0emwM/fYeAaMPWrHGLOjoOXwQQoBjcWkOwcSKq3kDUpmgcc6cXVJru/fhDQ7J3jtslss+ZtC8baa5OhXAk+oD4HBDKTrAYn+lXL8f6cnP5V0A2pL4FNpPYTN20I2ZXUfoJQpA6UhGMwwytBnfrmDhGOcOoRuysw4KMk7nJGKfy9rjUBbsVJAgMBAAECggEAMv4mTyK+M4244zQF/6so6Ri4mopl4fBja+X9wNixoi70Eev4BSZh5p+8NkhXGVdaRcV1dFXz3tInXJBD959XbKltoUyttWc/GzKYkm5sZ3z16dLpMtS/NbasPZ9sdpN603V6jTZ9qGh+Ko7xl8CvSCDwJY6yB+YmtxHAgyYML77jiIwscYonQI85p+DI2m22LrtTHU12geQ4NLm5MstIbPTd6bkyUPY6TJKMzabN5ci+sfay7V39hG8MAMoAi208ujrHgNl/1hDeZWtm9mNAiW+lH4MNNUoBj5TOQUlliAPj9aKiHQG3BhKjt031Qquq/HyP5BKZnEYl6PwTTY6SBQKBgQDIelEM+bWH0vW480tcf7U0GdMfsy+FUqHzv2IaIci66awHWmvcq0Ko7tmMBD8Af1GlAmwbCBvwaK8895V8uQ9Ip2Crx42or0TUpQ82CzhgMQ10cS+g62oZk+fGH433Q26PqPgZwXV+I/nRv4u4Gvqn7DA1s86VkY1QvxD2+8bniwKBgQCwviXwdQYxkRasj80Qz9j70LFaRwPr8hCeF8ivForVSg/lNqxFETSoTT/Jgj8QGXzi7lKmU7Vv8+4jBa2R18tWSqYX3TcbtnqghXx2RCCN9hzvLWvN2aaWtc6v0//Dj/cBONxy3kIU6x1hXbSOFVHxGV8njalWw5tNWrKy63VA+wKBgQCpQrxTnDCr8G0OLjueaSRwTK13wi2I/u9FgHwvW/7B8LARtUIEGYQ6ZQ6/rIYUwWoJSzZCzGHqZDgv3UkU+Jny2X5BCkaL+Q7ACmwBUQ/UBxY5DacM0jXOSpYRLGsMLJ6YJCz0ceXlDjLJ6FLqqbyfMkax0JHGrhEF74s/O+v/aQKBgFugB90TXcWeeMm2ttGLXuqUswyhGihcUj8TB2e1YP3XqkvivwYDOHAzs+jMS9MV04d1k4VEih/irkabr/KWk4RFqLtgZCxKumGzMeXBxbqypydbPbL2rYUd9WtzlPkWDjAlASvPiyR7Cr0qLesmpFdAFvNTXkFroHxGk7Nrm1q3AoGAMTeMB5eDMoje0nKhkkz417Fgag/67j7QLuMuck5VWdbZ/5Nj8fWiF1h46c/GzP8QVll9nh5Ms41f8HwiJTUFDGDgkle5KLnSRq/J31gycXl1BEX5fDZDbiURNrtMfn2JpmbQojqPH9Vu/nkJZmgPdMf+v3gbmn6bBqV6/ryvXMI="));
  final rsaPvtKey = crypton.RSAPrivateKey.fromString("MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2uTkrAdUVkaFFrHPZP6xO01HC929FcxBP74kZ8QcLy8pVOSAxxLdKFtr8b1r1Ea0A9ase+YgE3F66SBQ/CT7bGSabBHG47kQmz8VWoeytUwaZ/NeU4ybTjuE/a9KtfqL2ppjxmzMdA4UWoIF/GXCw6qolMPn9wxu/V2xHgderIp+c3kuS6C7GkHVpLxmPy7n6JcS7vyKBhpY/qoWF5+sDqGrOZ+6v/qAGsuTh1OGm7gj+LxQI2ctEhPvFpsYzgypV4VZ5iA3qHxXgLRwqlcH7dj5SG6j6hoxLpxwL4dO3tFRC6US9fX9aSt6Zf2YxSk8VKrPOzxNvzAcntCORRvgrAgMBAAECggEBAKv0tasWh1xL95RlDYT2mgZ4cipjxxB5j3FagBCsti/QsfHv169ebAtKZP1JIjUdVE1h5I86z1mbtX3jFUKZRdDU43LhBNC/Ud2gjBrSObSHPOAvhQX1mvVfMfUIWHSzh1NNRwOgRcLZLCc2F4fv/hBQVpy3cZvxQCyabikBNWAzlBqlu6bhveM5UBbgVWOz1FOPa8eZo5f7BXM9oLPwhPf/uKUMIqeZUuabH6l07Dx/gNJRaAaVwmMNXi43eGu82k/18oIJuNqPBzRLvB2owS/q0j/Wv9/7pFHZE/IiLQ5XVM7ITyq4odN3fderQ7ju+96u1jmZzF99oDrGnJUjFYkCgYEA9F25dOr58Siq0r+O7CJH7kULmW1pXdtZSnHwtQ2EfVvdMm99phTkE65ohTCK1SLQl7f37+jADKGh6iQodxG+nAkc8Ke12HJjgjCMrfVtVhxc5uyY5awTQHmD7DT57/1OO44zz53nt9/aF6h4b1JeosR9z5MYPjYWBNFWJiV4lJ8CgYEAv2w2v3eUoVb0fFIqsk+g04SBfT4VPCoXNT0kGpatAGEsbuWBZgYMhUfQ4Ql8qjcechWc41TjFlF/0o+xLbV4+EID+1O1+tL9A90sbkjtu+Zrw1B4bssWkgZ5Hg1uGsYU6Ru6D5pspZHv1N7zN6fOwE+VvSKZAFSHe+zAPeaJxPUCgYEAs/bmYzW+Fx3VGFpdHohsowyUa00JoUaursXU+PHYlh32fHNhfNO72MbEUPqb9DWsm1+wKC4oaeULgo1Yg8A8uVt4xb8tjBdKM5IfuOmbuSQwQx0RyWt9zijvwCCPxW+ukuu6OnfXNDKWwn+fGpT1/zdoVFvHKeHZO3kT0gockI8CgYAxGKc+GoSTkQLp9AUhcMz2E1FG9yppIP6M2B6vdx/uLf5AfzreGQUTFiVb4pwH6FU1u5des0H/Um3vao1uBNJ/EieFSaYuK/lbCVpA+xGGlQXktXn+KLakQ2bDL3yi/1UTqNni8J+XI8QYnApTpwWfS4pDVWFatVN+lG2GMt/5FQKBgCB3mAUPJBMCYkku2y0Ej525JnBb4ZMjdQBQkRn/VLHki9n4oHcPSlZcnrlIMFTBykE31lufS61qMdH/TTd0LveJrR0AkkJ7jdgIFENSOuJBXJKwKkTlK19nFEMJewdZAuJgE8tz66KhIaio9hLAPxsofPNRhY9x8ogYCbtY3b9o");
  final Decrypt = rsaPvtKey.decrypt(RSA_Encrypt);
  return Decrypt;
  //RSA Decryption of file is working!!!
}

//Encrypts the hash from encrypt_AES. RSA PKCS1 signing can't encrypt anything higher than 2048 bits or 256 bytes. Dynamic method outputs a dynamic var that will hold a String.
dynamic encrypt_RSA(dynamic RSA_Encrypt) {
  var setPubKey = App_Encrypt().getRSAPubKey();
  var getPubKey = setPubKey.publicKey.encrypt(RSA_Encrypt.toString());
  return getPubKey;
}

//Decrypts the AES_ECB Encryption. It will take a String and output a String.
dynamic decryptAES(dynamic encrypted, var decryptKey) {
  var iv = App_Encrypt().getIV;
  var key1 = encrypt.Key.fromBase64(decryptKey); // THIS LINE IS IMPORTANT FOR AES DECRYPTION OF A FILE!!!!!!!!!!!!
  dynamic init = App_Encrypt().getAESInit(key1);
  dynamic decrypt = init.decrypt64(encrypted, iv:iv);
  return decrypt;

  //AES Decryption of a file is working!!!!!
}