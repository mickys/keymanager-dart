import 'package:flutter_test/flutter_test.dart';
import 'package:keymanager/keymanager.dart';

void main() async {

//   String mnemonic = "exchange neither monster ethics bless cancel ghost excite business record warfare invite";
  // String mnemonic = "skin opera hungry bundle relief meadow act unlock click only race whale";
  // String ethereumWallet0privateKey = "0xe49c840fcb71fafcaa068c7d45a6b99f8d5b6064effe7d793b6490641e75cca8";
  // String ethereumWallet0publicKey = "0x30bfa6298178e3ab1f4a2e5d5c3c7d79505c0b3ef7958ac0fec319a67d3e47eb01f05a7059311a6d061b7a4c1eff38549909b0782256e22f748cb9e6f3c4c4a4";
  // String ethereumWallet0address = "0x9d9216e0a29468be1ecacc351ce3887be8a26222";
  // String signedMessage = "0x9cfd50e94fe93fd9d851085d119295e0b9c7a34ea5b8744fb359031c00ffcfd86455b222018c62607d8ea31d85d721ed73e34dd15cd4ca256c14438b870b9c7b1b";
  
  // String mnemonic2 = "seat senior relief nation blade security wisdom coral place rely furnace umbrella";
  
  // final myKeyManager = new KeyManager(mnemonic2);
  // await myKeyManager.init();

  // test('Generates correct wallet 0 private key', () {
  //   expect(myKeyManager.keys["wallet_privateKey"], ethereumWallet0privateKey);
  // });

  // test('Generates correct wallet 0 public key', () {
  //   expect(myKeyManager.keys["wallet_publicKey"], ethereumWallet0publicKey);
  // });

  // test('Generates correct wallet 0 address', () {
  //   expect(myKeyManager.keys["wallet_address"], ethereumWallet0address);
  // });

  // test('Generates all 6 keys', () {
  //   expect(myKeyManager.keys["wallet_privateKey"].length, 66);
  //   expect(myKeyManager.keys["storage_privateKey"].length, 66);
  //   expect(myKeyManager.keys["comms_privateKey"].length, 66);

  //   expect(myKeyManager.keys["wallet_publicKey"].length, 130);
  //   expect(myKeyManager.keys["storage_publicKey"].length, 130);
  //   expect(myKeyManager.keys["comms_publicKey"].length, 130);
  // });

  String key = "0x58c00e6af3e9ecca722c48bddbdfcb696f6939813dc1bad20cef5d852009055e";
  String signerAddress = "0x92faf690c46692df4203fce7263e20437d3dabc0";

  String msg = '{"data":{"data":"Register","date":"2021-01-27 21:47:40","e":251},"address":"0x92faf690c46692df4203fce7263e20437d3dabc0"}';
  String signedMessage = "0x2c4672e19bd21e85d27b6c61dd37b009f2a191f3b7e943870c4d7a97d49164ae0035b510e1e86d9b6dbf53e2cd5817cce0d88833647ce33cf70279cdb0c7354d1c";
  test('signPersonalMessage returns correct string', () {

    String signed = KeyManagerUtils.signPersonalMessage(msg, key);
    expect(signed, signedMessage);
  });

  test('getPublicKeyFromSignature returns correct address', () {
    String address = KeyManagerUtils.getPublicKeyFromSignature(msg, signedMessage);
    expect(address, signerAddress);
  });


  String msgOK = '{"data":{"data":"Register","date":"2021-01-27 21:47:40","e":15},"address":"0x92faf690c46692df4203fce7263e20437d3dabc0"}';
  String signedMessageOK = "0xfef866e78e6af346320136c4773cf1d0c6f5dd2340c32d9ec7ac0471df47f47934c8086f405a9680780fe2863176e8a7c3849a18c4c290361180c2ea9ce20ca81b";

  test('signPersonalMessage OK returns correct string', () {
    String signed = KeyManagerUtils.signPersonalMessage(msgOK, key);
    expect(signed, signedMessageOK);
  });

  test('getPublicKeyFromSignature OK returns correct address', () {
    String address = KeyManagerUtils.getPublicKeyFromSignature(msgOK, signedMessageOK);
    expect(address, signerAddress);
  });

  // // debug
  // print("wallet_privateKey:  " + myKeyManager.keys["wallet_privateKey"]);
  // print("wallet_publicKey:   " + myKeyManager.keys["wallet_publicKey"]);
  // print("wallet_address:     " + myKeyManager.keys["wallet_address"]);
  // print("storage_privateKey: " + myKeyManager.keys["storage_privateKey"]);
  // print("storage_publicKey:  " + myKeyManager.keys["storage_publicKey"]);
  // print("comms_privateKey:   " + myKeyManager.keys["comms_privateKey"]);
  // print("comms_publicKey:    " + myKeyManager.keys["comms_publicKey"]);


}
