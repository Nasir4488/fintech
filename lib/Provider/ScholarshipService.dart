import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class ScholarshipService extends GetxController {
  final String rpcUrl = "https://sepolia.infura.io/v3/b80dbc81d9e64be4b40b37f578a207ae";
  final String privateKey = "1b4c567939dd1b2f71760df3f0f6f6469e19727cb5dd977be4474019a5220fd0";

  // Your new deployed contract address
  final String contractAddress = "0x8623bd8b9df29d39286f331dc042489aa6d65975";

  late Web3Client _client;
  late EthPrivateKey _credentials;
  late DeployedContract _contract;

  EthPrivateKey get credentials => _credentials;

  Future<void> init() async {
    _client = Web3Client(rpcUrl, Client());
    _credentials = EthPrivateKey.fromHex(privateKey);

    final abiString = await rootBundle.loadString("assets/ScholarshipManager.json");
    final abiJson = jsonDecode(abiString);

    _contract = DeployedContract(
      ContractAbi.fromJson(jsonEncode(abiJson["abi"]), "ScholarshipManager"),
      EthereumAddress.fromHex(contractAddress),
    );
  }

  Future<String> createScholarship(String scholarshipName) async {
    final createFunction = _contract.function("createScholarship");
    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: createFunction,
        parameters: [scholarshipName],
      ),
      chainId: 11155111,
    );
    print("createScholarship tx: $txHash");
    return txHash;
  }

  Future<String> addApplicants(String scholarshipName, List<String> names) async {
    final addFunction = _contract.function("addApplicants");
    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: addFunction,
        parameters: [scholarshipName, names],
      ),
      chainId: 11155111,
    );
    print("addApplicants tx: $txHash");
    return txHash;
  }

  Future<String> selectWinnersByNames(String scholarshipName, List<String> selectedNames) async {
    final selectFunction = _contract.function("selectWinnersByNames");
    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: selectFunction,
        parameters: [scholarshipName, selectedNames],
      ),
      chainId: 11155111,
    );
    print("selectWinners tx: $txHash");
    return txHash;
  }

  Future<String> deleteScholarship(String scholarshipName) async {
    final deleteFunction = _contract.function("deleteScholarship");
    final txHash = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: deleteFunction,
        parameters: [scholarshipName],
      ),
      chainId: 11155111,
    );
    print("deleteScholarship tx: $txHash");
    return txHash;
  }

  Future<String> resetAllScholarships() async {
    final resetFunction = _contract.function("resetAllScholarships");
    final tx = await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: resetFunction,
        parameters: [],
      ),
      chainId: 11155111,
    );
    return tx;
  }

  Future<List<String>> getAllScholarshipNames() async {
    try {
      final getAllFunction = _contract.function("getAllScholarshipNames");
      final result = await _client.call(
        contract: _contract,
        function: getAllFunction,
        params: [],
      );

      if (result.isNotEmpty && result[0] is List) {
        return (result[0] as List).cast<String>();
      }
      return [];
    } catch (e) {
      print("Error getting scholarship names: $e");
      return [];
    }
  }

  Future<List<String>> getScholarshipApplicants(String scholarshipName) async {
    try {
      final getApplicantsFunction = _contract.function("getScholarshipApplicants");
      final result = await _client.call(
        contract: _contract,
        function: getApplicantsFunction,
        params: [scholarshipName],
      );

      if (result.isNotEmpty && result[0] is List) {
        return (result[0] as List).cast<String>();
      }
      return [];
    } catch (e) {
      print("Error getting applicants for $scholarshipName: $e");
      return [];
    }
  }

  Future<List<String>> getScholarshipWinners(String scholarshipName) async {
    try {
      final getWinnersFunction = _contract.function("getScholarshipWinners");
      final result = await _client.call(
        contract: _contract,
        function: getWinnersFunction,
        params: [scholarshipName],
      );

      if (result.isNotEmpty && result[0] is List) {
        return (result[0] as List).cast<String>();
      }
      return [];
    } catch (e) {
      print("Error getting winners for $scholarshipName: $e");
      return [];
    }
  }

  Future<String> getAdmin() async {
    final adminFunction = _contract.function("admin");
    final result = await _client.call(
      contract: _contract,
      function: adminFunction,
      params: [],
    );
    return result.first.toString();
  }

  Future<void> waitForReceipt(String txHash) async {
    print("Waiting for transaction receipt: $txHash");
    TransactionReceipt? receipt;
    int attempts = 0;
    while (receipt == null && attempts < 30) {
      await Future.delayed(Duration(seconds: 2));
      try {
        receipt = await _client.getTransactionReceipt(txHash);
        if (receipt != null) {
          print("Transaction confirmed: $txHash");
          break;
        }
      } catch (e) {
        print("Error getting receipt (attempt ${attempts + 1}): $e");
      }
      attempts++;
    }

    if (receipt == null) {
      print("Transaction timeout: $txHash");
      throw Exception("Transaction timeout after 60 seconds");
    }
  }

  // Fallback method (shouldn't be needed with new contract)
  Future<List<String>> getScholarshipsFromEvents() async {
    return await getAllScholarshipNames();
  }

  Future<void> debugContract() async {
    print("=== NEW CONTRACT DEBUG ===");

    try {
      await init();

      final admin = await getAdmin();
      final yourAddress = await credentials.address;
      print("Your address: $yourAddress");
      print("Contract admin: $admin");
      print("Are you admin? ${yourAddress.toString().toLowerCase() == admin.toLowerCase()}");

      final scholarships = await getAllScholarshipNames();
      print("✅ Scholarships found: $scholarships");

      if (scholarships.isNotEmpty) {
        for (String scholarship in scholarships) {
          final applicants = await getScholarshipApplicants(scholarship);
          final winners = await getScholarshipWinners(scholarship);
          print("📚 $scholarship: ${applicants.length} applicants, ${winners.length} winners");
        }
      }

    } catch (e) {
      print("Debug error: $e");
    }

    print("=== END DEBUG ===");
  }
}