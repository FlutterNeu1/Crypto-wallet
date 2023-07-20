import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'generate_mnemonic_page.dart';
import 'import_wallet.dart';

class CreateOrImportPage extends StatelessWidget {
  const CreateOrImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff141627),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              alignment: Alignment.center,
              child: const Text(
                'Crypto  Wallet',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: "Mukta-Regular",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // Logo
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
                  width: 350,
                  height: 300,
                  child: Lottie.network(
                      "https://lottie.host/abcde349-95c6-4940-8cdd-edbecaef23fe/UztCxRdFTi.json",
                      height: 300,
                      width: 250)),
            ),
            const SizedBox(height: 50.0),

            // Login button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(8), // Adjust border radius as needed
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GenerateMnemonicPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .transparent, // Set the button's background color to transparent
                  onPrimary: Colors.white, // Set the text color
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'Create Wallet',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Register button
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(8), // Adjust border radius as needed
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Add your register logic here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImportWallet(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .transparent, // Set the button's background color to transparent
                  onPrimary: Colors.white, // Set the text color
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text(
                  'Import from Seed',
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // Footer
          ],
        ),
      ),
    );
  }
}
