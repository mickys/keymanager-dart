import 'package:flutter_test/flutter_test.dart';
import 'package:keymanager/keymanager.dart';

void main() async {

  String mnemonic = "exchange neither monster ethics bless cancel ghost excite business record warfare invite";
  String ethereumWallet0privateKey = "e49c840fcb71fafcaa068c7d45a6b99f8d5b6064effe7d793b6490641e75cca8";
  String ethereumWallet0publicKey = "30bfa6298178e3ab1f4a2e5d5c3c7d79505c0b3ef7958ac0fec319a67d3e47eb01f05a7059311a6d061b7a4c1eff38549909b0782256e22f748cb9e6f3c4c4a4";
  String ethereumWallet0address = "0x9d9216e0a29468be1ecacc351ce3887be8a26222";

  final myKeyManager = new KeyManager(mnemonic);
  await myKeyManager.init();

  test('Generates correct wallet 0 private key', () {
    expect(myKeyManager.keys["wallet_privateKey"], ethereumWallet0privateKey);
  });

  test('Generates correct wallet 0 public key', () {
    expect(myKeyManager.keys["wallet_publicKey"], ethereumWallet0publicKey);
  });

  test('Generates correct wallet 0 address', () {
    expect(myKeyManager.keys["wallet_address"], ethereumWallet0address);
  });

  test('Generates all 6 keys', () {
    expect(myKeyManager.keys["wallet_privateKey"].length, 64);
    expect(myKeyManager.keys["storage_privateKey"].length, 64);
    expect(myKeyManager.keys["comms_privateKey"].length, 64);

    expect(myKeyManager.keys["wallet_publicKey"].length, 128);
    expect(myKeyManager.keys["storage_publicKey"].length, 128);
    expect(myKeyManager.keys["comms_publicKey"].length, 128);
  });

  // debug
  print("wallet_privateKey:  " + myKeyManager.keys["wallet_privateKey"]);
  print("wallet_publicKey:   " + myKeyManager.keys["wallet_publicKey"]);
  print("wallet_address:     " + myKeyManager.keys["wallet_address"]);
  print("storage_privateKey: " + myKeyManager.keys["storage_privateKey"]);
  print("storage_publicKey:  " + myKeyManager.keys["storage_publicKey"]);
  print("comms_privateKey:   " + myKeyManager.keys["comms_privateKey"]);
  print("comms_publicKey:    " + myKeyManager.keys["comms_publicKey"]);

  
}
