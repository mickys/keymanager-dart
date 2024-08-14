library keymanager;

import 'dart:collection';
import 'dart:typed_data';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;

// import 'package:blockchain_utils/bip/address/eth_addr.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:blockchain_utils/crypto/crypto/cdsa/point/base.dart';


class KeyManager {
  late bip32.BIP32 rootkey;
  late String _mnemonic;

  final String _derrivationPathWallet = 'm/44\'/60\'/0\'/0';
  final int _derrivationChildWallet = 0;
  final String _derrivationPathStorage = 'm/0\'/60\'/0\'/0';
  int _derrivationChildStorage = 0;
  final String _derrivationPathCommunication = 'm/1\'/60\'/0\'/0';
  final int _derrivationChildCommunication = 0;

  final HashMap<String,String> _keys = HashMap();

  KeyManager(String mnemonic) {
    _mnemonic = mnemonic;
  }

  KeyManager.fromMnemonic(String mnemonic) {
    _mnemonic = mnemonic;
  }

  Future<void> init() async {

    rootkey = bip32.BIP32.fromSeed(bip39.mnemonicToSeed(_mnemonic));

    Uint8List seed = bip39.mnemonicToSeed(_mnemonic);
    rootkey = bip32.BIP32.fromSeed(seed);

    bip32.BIP32 keyWallet = rootkey.derivePath(_derrivationPathWallet).derive(_derrivationChildWallet);
    bip32.BIP32 keyStorage = rootkey.derivePath(_derrivationPathStorage).derive(_derrivationChildStorage);
    bip32.BIP32 keyStorageVdb =  rootkey.derivePath(_derrivationPathStorage).derive(++_derrivationChildStorage);
    bip32.BIP32 keyStorageVdc =  rootkey.derivePath(_derrivationPathStorage).derive(++_derrivationChildStorage);
    bip32.BIP32 keyComms = rootkey.derivePath(_derrivationPathCommunication).derive(_derrivationChildCommunication);

    _keys["wallet_privateKey"] = _getPrivate(keyWallet);

    _keys["wallet_publicKey"] = _privateToPublic(keyWallet);
    _keys["wallet_address"] = _publicKeyToAddress(keyWallet);

    _keys["storage_root_privateKey"] = _getPrivate(keyStorage);
    _keys["storage_root_publicKey"] = _privateToPublic(keyStorage);

    _keys["storage_vdb_privateKey"] = _getPrivate(keyStorageVdb);
    _keys["storage_vdb_publicKey"] = _privateToPublic(keyStorageVdb);

    _keys["storage_vdc_privateKey"] = _getPrivate(keyStorageVdc);
    _keys["storage_vdc_publicKey"] = _privateToPublic(keyStorageVdc);


    _keys["comms_privateKey"] = _getPrivate(keyComms);
    _keys["comms_publicKey"] = _privateToPublic(keyComms);

  }

  String _getPrivate(dynamic key) {
    return "0x${BytesUtils.toHexString(key.privateKey)}";
  }

  String _privateToPublic(dynamic key) {
    return "0x${BytesUtils.toHexString(
      ETHSigner.fromKeyBytes(key.privateKey)
        .toVerifyKey().edsaVerifyKey.publicKey.toBytes(EncodeType.raw)
    )}";
  }

  String _publicKeyToAddress(dynamic key) {
    return "0x${EthAddrEncoder().encodeKey(
      BytesUtils.fromHexString(
        _privateToPublic(key)
      ),
      {"skip_chksum_enc": true}
    )}";
  }
  
  HashMap<String,String> get keys {
    return _keys;
  }

}

class KeyManagerUtils {

  static String signPersonalMessage(String message, String privateKey) {

    final signer = ETHSigner.fromKeyBytes(BytesUtils.fromHexString(privateKey));
    final encodedMessage = BytesUtils.fromHexString(
      hex.encode(
        StringUtils.encode(message, type: StringEncoding.ascii)
      )
    );
    final sign = signer.signProsonalMessage(encodedMessage);
    return "0x${BytesUtils.toHexString(sign)}";
  }

  static String getPublicKeyFromSignature(String message, String signed) {
    
    final encodedMessage = BytesUtils.fromHexString(
      hex.encode(
        StringUtils.encode(message, type: StringEncoding.ascii)
      )
    );

    ECDSAPublicKey? publicKey = ETHVerifier.getPublicKey(encodedMessage, BytesUtils.fromHexString(signed));
    final publicKeyBytes = publicKey?.toBytes();

    List<int> realPubKey = List.empty();
    if(publicKeyBytes != null) {
      realPubKey = publicKeyBytes;
    }
    
    return "0x${EthAddrEncoder().encodeKey(realPubKey, {"skip_chksum_enc": true})}";
  }
}
