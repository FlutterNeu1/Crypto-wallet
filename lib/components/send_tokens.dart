import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';

class SendTokensPage extends StatelessWidget {
  final String privateKey;
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  SendTokensPage({Key? key, required this.privateKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141627),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: recipientController,
              cursorColor: Colors.purpleAccent,
              decoration: InputDecoration(
                hintText: 'Enter Recipient adress',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 139, 86, 224), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: amountController,
              decoration: InputDecoration(
                hintText: 'Amount',
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 139, 86, 224), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xffFF007B), Color(0xff5D50FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(8), // Adjust border radius as needed
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                  String recipient = recipientController.text;
                  double amount = double.parse(amountController.text);
                  BigInt bigIntValue = BigInt.from(amount * pow(10, 18));
                  print(bigIntValue);
                  EtherAmount ethAmount =
                      EtherAmount.fromBigInt(EtherUnit.wei, bigIntValue);
                  print(ethAmount);
                  // Convert the amount to EtherAmount
                  sendTransaction(recipient, ethAmount);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .transparent, // Set the button's background color to transparent
                  onPrimary: Colors.white, // Set the text color
                  padding: EdgeInsets.all(16), // Adjust padding as needed
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Adjust border radius as needed
                  ),
                ),
                child: Text('Send'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendTransaction(String receiver, EtherAmount txValue) async {
    var apiUrl =
        "https://eth-sepolia.g.alchemy.com/v2/l0AcKzzAKaaVmJfVKGYk8RgpTiAWrnFu";

    var httpClient = http.Client();
    var ethClient = Web3Client(apiUrl, httpClient);

    EthPrivateKey credentials = EthPrivateKey.fromHex('0x' + privateKey);

    EtherAmount etherAmount = await ethClient.getBalance(credentials.address);
    EtherAmount gasPrice = await ethClient.getGasPrice();

    print(etherAmount);

    await ethClient.sendTransaction(
      credentials,
      Transaction(
        to: EthereumAddress.fromHex(receiver),
        gasPrice: gasPrice,
        maxGas: 100000,
        value: txValue,
      ),
      chainId: 11155111,
    );
  }
}
