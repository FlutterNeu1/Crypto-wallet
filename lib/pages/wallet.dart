import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/swipeablecard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:web3dart/web3dart.dart';

import 'dart:convert';

import '../components/send_tokens.dart';
import '../providers/wallet_provider.dart';
import '../utils/get_balances.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String walletAddress = '';
  String balance = '';
  String pvKey = '';

  @override
  void initState() {
    super.initState();
    loadWalletData();
  }

  Future<void> loadWalletData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? privateKey = prefs.getString('privateKey');
    if (privateKey != null) {
      final walletProvider = WalletProvider();
      await walletProvider.loadPrivateKey();
      EthereumAddress address = await walletProvider.getPublicKey(privateKey);
      print(address.hex);
      setState(() {
        walletAddress = address.hex;
        pvKey = privateKey;
      });
      print(pvKey);
      String response = await getBalances(address.hex, 'eth');
      dynamic data = json.decode(response);
      String newBalance = data['balance'] ?? '0';

      // Transform balance from wei to ether
      EtherAmount latestBalance =
          EtherAmount.fromBigInt(EtherUnit.wei, BigInt.parse(newBalance));
      String latestBalanceInEther =
          latestBalance.getValueInUnit(EtherUnit.ether).toString();

      setState(() {
        balance = latestBalanceInEther;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141627),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
            child: Row(
              children: [
                ShaderMask(
                  // Use LinearGradient to define the gradient color
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 139, 86, 224),
                        Color.fromARGB(255, 139, 86, 224)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Mukta-Regular",
                      color: Colors
                          .white, // Set the text color to white to see the gradient effect
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: SwipableCard(),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 130),
                child: FloatingActionButton(
                  heroTag: 'sendButton', // Unique tag for send button
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendTokensPage(privateKey: pvKey),
                      ),
                    );
                  },
                  backgroundColor:
                      Colors.purple, // Set the background color of the icon
                  child: const Icon(Icons.send),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20),
                child: FloatingActionButton(
                  heroTag: 'refreshButton',
                  onPressed: () {
                    setState(() {});
                  },
                  backgroundColor: Colors.purple,
                  child: const Icon(Icons.replay_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
