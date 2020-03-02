library keymanager;

import 'dart:collection';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';

class KeyManager {
  bip32.BIP32 rootkey;
  String _mnemonic;

  String _derrivationPathWallet = 'm/44\'/60\'/0\'/0';
  int _derrivationChildWallet = 0;
  String _derrivationPathStorage = 'm/0\'/60\'/0\'/0';
  int _derrivationChildStorage = 0;
  String _derrivationPathCommunication = 'm/1\'/60\'/0\'/0';
  int _derrivationChildCommunication = 0;

  HashMap<String,String> _keys = new HashMap();

  KeyManager(String _mnemonic) {
    this._mnemonic = _mnemonic;
  }

  KeyManager.fromMnemonic(String _mnemonic) {
    this._mnemonic = _mnemonic;
  }

  Future<void> init() async {
    this.rootkey = bip32.BIP32.fromSeed(bip39.mnemonicToSeed(this._mnemonic));
    
    bip32.BIP32 keyWallet = this.rootkey.derivePath(this._derrivationPathWallet).derive(this._derrivationChildWallet);
    bip32.BIP32 keyStorage = this.rootkey.derivePath(this._derrivationPathStorage).derive(this._derrivationChildStorage);
    bip32.BIP32 keyComms = this.rootkey.derivePath(this._derrivationPathCommunication).derive(this._derrivationChildCommunication);

    this._keys["wallet_privateKey"] = this._getPrivate(keyWallet);
    this._keys["wallet_publicKey"] = this._privateToPublic(keyWallet);
    String address = await this._publicKeyToAddress(keyWallet);
    this._keys["wallet_address"] = address;

    this._keys["storage_privateKey"] = this._getPrivate(keyStorage);
    this._keys["storage_publicKey"] = this._privateToPublic(keyStorage);
    this._keys["comms_privateKey"] = this._getPrivate(keyComms);
    this._keys["comms_publicKey"] =this._privateToPublic(keyComms);

  }

  String _getPrivate(dynamic _key) {
    return hex.encode(_key.privateKey);
  }

  String _privateToPublic(dynamic _key) {
    return hex.encode(privateKeyBytesToPublic(_key.privateKey));
  }

  Future<String> _publicKeyToAddress(dynamic _key) async {
    Credentials privateKey = EthPrivateKey.fromHex( this._getPrivate(_key) );
    var address = await privateKey.extractAddress();
    // privateKey.
    // privateKeyBytesToPublic(hex.decode(key));

    return address.toString();
  }
  
  HashMap<String,String> get keys {
    return this._keys;
  }

}
