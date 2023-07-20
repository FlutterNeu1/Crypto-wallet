import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/verify_mnemonic_page.dart';
import 'package:provider/provider.dart';

import '../providers/wallet_provider.dart';

class GenerateMnemonicPage extends StatelessWidget {
  const GenerateMnemonicPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final mnemonic = walletProvider.generateMnemonic();
    final mnemonicWords = mnemonic.split(' ');

    void copyToClipboard() {
      Clipboard.setData(ClipboardData(text: mnemonic));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mnemonic Copied to Clipboard')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyMnemonicPage(mnemonic: mnemonic),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xff141627),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                'Please store this mnemonic phrase safely:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: "Mukta-Regular",
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Set the default text color
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                (mnemonicWords.length / 3)
                    .ceil(), // Calculate the number of rows needed
                (rowIndex) => Row(
                  children: List.generate(
                    3, // Number of items in each row
                    (colIndex) {
                      final index = rowIndex * 3 + colIndex;
                      if (index < mnemonicWords.length) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 96, 0, 252)),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${index + 1}. ${mnemonicWords[index]}',
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                            child: Container()); // Placeholder for empty cells
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
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
              child: ElevatedButton.icon(
                onPressed: () {
                  copyToClipboard();
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy to Clipboard'),
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .transparent, // Set the button's background color to transparent
                  onPrimary: Colors.white, // Set the text color
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  textStyle: const TextStyle(fontSize: 20.0),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
