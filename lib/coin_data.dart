import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '3B086C67-70FC-4079-8D43-587D1E1CE48C';

class CoinData {
  Future<Map<String, String>> getCoinData(String currency) async {
    Map<String, String> coinData = Map();
    for (String crypto in cryptoList) {
      coinData[crypto] = (await getRate(crypto, currency)).floor().toString();
    }
    return coinData;
  }

  Future<double> getRate(String base, String quote) async {
    http.Response response = await http.get(coinAPIURL + '/$base/$quote', headers: {'X-CoinAPI-Key': apiKey});
    int statusCode = response.statusCode;
    print('Status code: $statusCode');
    if (statusCode == 200) {
      print('Requests remaining: ' + response.headers['x-ratelimit-remaining']);
      dynamic decoded = jsonDecode(response.body);
      return decoded['rate'];
    } else {
      //todo: in case of 429, too many request, give something like a popup warning
      throw 'Problem with the GET request';
    }
  }
}
