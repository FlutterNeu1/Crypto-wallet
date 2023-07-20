import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/wallet.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';

class VerifyMnemonicPage extends StatefulWidget {
  final String mnemonic;

  const VerifyMnemonicPage({Key? key, required this.mnemonic})
      : super(key: key);

  @override
  _VerifyMnemonicPageState createState() => _VerifyMnemonicPageState();
}

class _VerifyMnemonicPageState extends State<VerifyMnemonicPage> {
  bool isVerified = false;
  String verificationText = '';

  void verifyMnemonic() {
    final walletProvider = Provider.of<WalletProvider>(context, listen: false);

    if (verificationText.trim() == widget.mnemonic.trim()) {
      walletProvider.getPrivateKey(widget.mnemonic).then((privateKey) {
        setState(() {
          isVerified = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToWalletPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WalletPage()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff141627),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              child: const Text(
                'Verify the Mnemonic to enter the wallet',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Mukta-Regular",
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set the default text color
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  verificationText = value;
                });
              },
              decoration: InputDecoration(
                enabled: true,
                hintText: 'Enter Mnemonic phrase',
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
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(8), // Adjust border radius as needed
              ),
              child: ElevatedButton(
                onPressed: () {
                  verifyMnemonic();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .transparent, // Set the button's background color to transparent
                  onPrimary: Colors.white, // Set the text color
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(8), // Adjust border radius as needed
              ),
              child: ElevatedButton(
                onPressed: isVerified ? navigateToWalletPage : null,
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .transparent, // Set the button's background color to transparent
                  onPrimary: Colors.white, // Set the text color
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
