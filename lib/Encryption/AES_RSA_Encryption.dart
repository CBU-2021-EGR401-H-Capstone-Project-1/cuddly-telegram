// ignore_for_file: non_constant_identifier_names
import 'package:basic_utils/basic_utils.dart';
import 'package:cuddly_telegram/Encryption/Read_Write.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypton/crypton.dart' as crypton;
import 'dart:math' as Math;
import 'dart:convert' as convert;
class App_Encrypt {


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
    final init = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ctr, padding: null));
    return init;
  }

}

main() async {
  //   var display = encrypt_AES("I FUCKING DID IT");
  //    var display2 = encrypt_RSA(display);
      //var display3 = decryptRSA("");
      //var display4 = decryptAES("uOfSa/3b+2DKSyE4YwY0rcbZP0GCYbC0WE+eN15Z5g==", "A+KNPztmqMbBYAXMyYp2Z6BgY3cgBq4VBUIQrbJm70s=");
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
      var pHolder = (y+244) - passedInput;
      display2 = encrypt_RSA(display.toString().substring(i, passedInput - pHolder));
    } else {
      display2 = encrypt_RSA(display.toString().substring(i, i + 244));
    }
    display3 += "$display3""$display2";
    display2 = "";
    y += 244;
  }
  final keyInst = App_Encrypt().getKey.base64;
  final rsaPvtInst = App_Encrypt().getRSAKeyPairing().privateKey.toString();
  final rsaPubInst = App_Encrypt().getRSAKeyPairing().publicKey.toString();
  await Read_Write().writeCounter(path, "RSA Output:$display3" + "\nAES_KEYinit: $keyInst" + "\nRSAPrivateKey: $rsaPvtInst" + "\nRSAPubKey: $rsaPubInst" + "\n length: ${display.length} , ${display3.length}");
}


Future<dynamic> Reader_WriterDecrypt(dynamic filePath) async {
  var path = Read_Write().userFile(setTakeUserPath(filePath));
  var holdFileContent = await Read_Write().testReading(path);
  final holdFileLength = holdFileContent.toString().length;
  String display = "";
  String rsa_SectorDecrypt = "";
  int y = 0;
  for(int i = 0; i <= holdFileLength; i+=244){
    if(y+244 > holdFileLength){
      var pHolder = (y+244) - holdFileLength;
      display = decryptRSA(holdFileContent.toString().substring(i, holdFileLength - pHolder));
    } else {
      display = decryptRSA(holdFileContent.toString().substring(i, i+244));
    }
    rsa_SectorDecrypt += "$rsa_SectorDecrypt""$display";
    display = "";
    y+=244;
  }
  display = decryptRSA(holdFileContent);
  dynamic display2 = decryptAES(display, "6bRLbNvX8387Cz/17xdLFRf02RaZBCy1EeWFzENpurs=");
  //dynamic display2 = decryptAES(display, App_Encrypt().getKey);
  await Read_Write().writeCounter(path, display2);
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
dynamic decryptRSA(dynamic RSA_Encrypt) async {
  dynamic holdFileContent = await Read_Write().testReading("/Users/ladmin/OneDrive - California Baptist University/Capstone_Current/lib/Encryption/holdKey.txt");
  dynamic text = holdFileContent;
  final rsaPvtKey = crypton.RSAPrivateKey.fromString(text.toString());
  final Decrypt = rsaPvtKey.decrypt(RSA_Encrypt);
  //final Decrypt = App_Encrypt().getRSAKeyPairing().privateKey.decrypt(RSA_Encrypt);
  return Decrypt;

  //RSA Decryption of file is working!!!
}

//Encrypts the hash from encrypt_AES. RSA PKCS1 signing can't encrypt anything higher than 2048 bits or 256 bytes. Dynamic method outputs a dynamic var that will hold a String.
dynamic encrypt_RSA(dynamic RSA_Encrypt) {
  dynamic Encrypt;
   Encrypt = App_Encrypt().getRSAKeyPairing().publicKey.encrypt(RSA_Encrypt.toString());
  return Encrypt;
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