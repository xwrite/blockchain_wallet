
import 'package:blockchain_wallet/app_config.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart';

///节点连接服务
class Web3Service extends GetxService{

  final _client = Web3Client(AppConfig.ethNetworkUrl, Client());

  Future<BigInt?> getBalance(String hexAddress) async{
    try{
      final address = EthereumAddress.fromHex(hexAddress);
      final balance = await _client.getBalance(address);
      logger.d('balance: ether=${balance.getInEther}  ,wei=${balance.getInWei}');
      return balance.getInEther;
    }catch(ex){
      logger.w(ex);
      return null;
    }
  }

}