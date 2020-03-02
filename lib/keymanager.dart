library keymanager;

import 'dart:collection';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

class KeyManager {
  bip32.BIP32 rootkey;

  String _derrivationPathWallet = 'm/44\'/60\'/0\'/0';
  int _derrivationChildWallet = 0;
  String _derrivationPathStorage = 'm/0\'/60\'/0\'/0';
  int _derrivationChildStorage = 0;
  String _derrivationPathCommunication = 'm/1\'/60\'/0\'/0';
  int _derrivationChildCommunication = 0;

  HashMap<String,String> _keys = new HashMap();

  KeyManager(String mnemonic) {
    init(bip39.mnemonicToSeed(mnemonic));
  }

  KeyManager.fromMnemonic(String mnemonic) {
    init(bip39.mnemonicToSeed(mnemonic));
  }

  void init(Uint8List _seed) {
    this.rootkey = bip32.BIP32.fromSeed(_seed);
    
    bip32.BIP32 keyWallet = this.rootkey.derivePath(this._derrivationPathWallet).derive(this._derrivationChildWallet);
    bip32.BIP32 keyStorage = this.rootkey.derivePath(this._derrivationPathStorage).derive(this._derrivationChildStorage);
    bip32.BIP32 keyComms = this.rootkey.derivePath(this._derrivationPathCommunication).derive(this._derrivationChildCommunication);

    this._keys["wallet_privateKey"] = hex.encode(keyWallet.privateKey);
    this._keys["wallet_publicKey"] = hex.encode(keyWallet.publicKey);
    this._keys["storage_privateKey"] = hex.encode(keyStorage.privateKey);
    this._keys["storage_publicKey"] = hex.encode(keyStorage.publicKey);
    this._keys["comms_privateKey"] = hex.encode(keyComms.privateKey);
    this._keys["comms_publicKey"] = hex.encode(keyComms.publicKey);
  }

  HashMap<String,String> get keys {
    return this._keys;
  }


}
