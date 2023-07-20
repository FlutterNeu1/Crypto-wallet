import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_application_1/providers/wallet_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

import 'package:flutter/services.dart';

import '../utils/get_balances.dart';

class SwipableCard extends StatefulWidget {
  @override
  _SwipableCardState createState() => _SwipableCardState();
}

class _SwipableCardState extends State<SwipableCard> {
  bool isCardExpanded = false;
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

  void toggleCard() {
    setState(() {
      isCardExpanded = !isCardExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCard, // Toggle the card on tap
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        flipOnTouch: true, // Prevent automatic flip on touch
        front: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 250,
          width: 400,
          // Use the Container with LinearGradient for the gradient background and rounded border
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffFF007B), Color(0xff5D50FE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50), // Set the border radius
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  walletAddress,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: walletAddress));
                  // Show a snackbar indicating the address is copied
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Wallet address copied to clipboard"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .transparent, // Set the background color to transparent
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Set the border radius of the button
                    side: const BorderSide(
                        color: Color.fromARGB(0, 255, 255,
                            255)), // Add a white border to make it visible
                  ),
                ),
                child: const Text(
                  "Copy",
                  style: TextStyle(
                      color: Colors.white), // Set the text color to white
                ),
              ),
            ],
          ),
        ),
        back: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 250,
          width: 400,
          // Use the Container with BoxDecoration for rounded border on the back
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffFF007B), Color(0xff5D50FE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50), // Set the border radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          balance,
                          style: const TextStyle(
                              fontSize: 34,
                              color: Colors.white,
                              fontFamily: "Mukta-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "SepoliaETH",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Mukta-Regular",
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
