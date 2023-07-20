import 'package:http/http.dart' as http;

Future<String> getBalances(String walletaddress, String chain) async {
  final url = Uri.http('192.168.1.19:5000', '/get_token_balance', {
    'address': walletaddress,
    'chain': 'sepolia',
  });

  final response = await http.get(url);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to get balances');
  }
}
