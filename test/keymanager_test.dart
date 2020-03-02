import 'package:flutter_test/flutter_test.dart';
import 'package:keymanager/keymanager.dart';

void main() {

  String mnemonic = "exchange neither monster ethics bless cancel ghost excite business record warfare invite";
  String ethereumWallet0PrivateKey = "e49c840fcb71fafcaa068c7d45a6b99f8d5b6064effe7d793b6490641e75cca8";
  final myKeyManager = new KeyManager(mnemonic);

  test('Generates correct wallet 0 private key', () {
    expect(myKeyManager.keys["wallet_privateKey"], ethereumWallet0PrivateKey);
  });

  test('Generates all 6 keys', () {
    expect(myKeyManager.keys["wallet_privateKey"].length, 64);
    expect(myKeyManager.keys["storage_privateKey"].length, 64);
    expect(myKeyManager.keys["comms_privateKey"].length, 64);

    expect(myKeyManager.keys["wallet_publicKey"].length, 66);
    expect(myKeyManager.keys["storage_publicKey"].length, 66);
    expect(myKeyManager.keys["comms_publicKey"].length, 66);
  });

}
