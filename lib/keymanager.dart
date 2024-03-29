library keymanager;

import 'dart:collection';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:ethereum_util/ethereum_util.dart';


class KeyManager {
  late bip32.BIP32 rootkey;
  late String _mnemonic;

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

    Uint8List seed = bip39.mnemonicToSeed(this._mnemonic);
    this.rootkey = bip32.BIP32.fromSeed(seed);

    bip32.BIP32 keyWallet = this.rootkey.derivePath(this._derrivationPathWallet).derive(this._derrivationChildWallet);
    bip32.BIP32 keyStorage = this.rootkey.derivePath(this._derrivationPathStorage).derive(this._derrivationChildStorage);
    bip32.BIP32 keyStorageVdb =  this.rootkey.derivePath(this._derrivationPathStorage).derive(++this._derrivationChildStorage);
    bip32.BIP32 keyStorageVdc =  this.rootkey.derivePath(this._derrivationPathStorage).derive(++this._derrivationChildStorage);
    bip32.BIP32 keyComms = this.rootkey.derivePath(this._derrivationPathCommunication).derive(this._derrivationChildCommunication);

    this._keys["wallet_privateKey"] = this._getPrivate(keyWallet);
    this._keys["wallet_publicKey"] = this._privateToPublic(keyWallet);
    this._keys["wallet_address"] = this._publicKeyToAddress(keyWallet);

    this._keys["storage_root_privateKey"] = this._getPrivate(keyStorage);
    this._keys["storage_root_publicKey"] = this._privateToPublic(keyStorage);

    this._keys["storage_vdb_privateKey"] = this._getPrivate(keyStorageVdb);
    this._keys["storage_vdb_publicKey"] = this._privateToPublic(keyStorageVdb);

    this._keys["storage_vdc_privateKey"] = this._getPrivate(keyStorageVdc);
    this._keys["storage_vdc_publicKey"] = this._privateToPublic(keyStorageVdc);


    this._keys["comms_privateKey"] = this._getPrivate(keyComms);
    this._keys["comms_publicKey"] =this._privateToPublic(keyComms);

  }

  String _getPrivate(dynamic _key) {
    return bufferToHex(_key.privateKey);
  }

  String _privateToPublic(dynamic _key) {
    return bufferToHex(privateKeyToPublicKey(_key.privateKey));
  }

  String _publicKeyToAddress(dynamic _key) {
    return bufferToHex(privateKeyToAddress(_key.privateKey));
  }
  
  HashMap<String,String> get keys {
    return this._keys;
  }

}

class KeyManagerUtils {

  static String signPersonalMessage(String _message, String _privateKey) {
    Uint8List msgHash = hashPersonalMessage(toBuffer(_message));
    ECDSASignature signature = sign(msgHash, Uint8List.fromList(hex.decode(stripHexPrefix(_privateKey))));
    return toRpcSig(signature.r, signature.s, signature.v);
  }

  static String getPublicKeyFromSignature(String _message, String _signed) {
    ECDSASignature signature = fromRpcSig(_signed);
    Uint8List msgHash = hashPersonalMessage(toBuffer(_message));
    Uint8List pubkey = recoverPublicKeyFromSignature(signature, msgHash);
    return bufferToHex(publicKeyToAddress(pubkey));
  }
}
