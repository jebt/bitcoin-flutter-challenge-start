import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0]; //todo: change default to EUR or USD
  Map<String, String> data;

  Widget getPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(
          currency,
          style: currency == 'EUR' || currency == 'USD' || currency == 'GBP'
              ? TextStyle(color: Colors.orange)
              : TextStyle(color: Colors.white),
        ),
      );
    }

    CupertinoPicker getCupertinoPicker() {
      return CupertinoPicker(
        itemExtent: 24.0,
        scrollController: FixedExtentScrollController(
          initialItem: currenciesList.indexOf(selectedCurrency),
          //initialItem: pickerItems.indexOf(pickerItems.firstWhere((element) => element.data == 'EUR')),
        ),
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (index) {
          String value = pickerItems[index].data;
          if (value != selectedCurrency) {
            setQuestionMarks(value);
            getData();
          }
        },
        children: pickerItems,
      );
    }

    DropdownButton<String> getDropdownButton() {
      List<DropdownMenuItem<String>> dropDownItems = [];
      for (Text item in pickerItems) {
        dropDownItems.add(
          DropdownMenuItem(
            child: item,
            value: item.data,
          ),
        );
      }
      return DropdownButton(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          if (value != selectedCurrency) {
            setQuestionMarks(value);
            getData();
          }
        },
      );
    }

    return Platform.isIOS ? getCupertinoPicker() : getDropdownButton();
    //return getCupertinoPicker();
  }

  void setQuestionMarks(String value) {
    setState(() {
      data = null;
      selectedCurrency = value;
    });
  }

  getData() async {
    //await Future.delayed(Duration(seconds: 3));
    Map<String, String> tData = await CoinData().getCoinData(selectedCurrency);
    setState(() {
      data = tData;
    });
  }

  @override
  void initState() {
    super.initState();
    setQuestionMarks(selectedCurrency);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    //todo: improve aesthetics like the button
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: cryptoCards(),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }

  List<Widget> cryptoCards() {
    List<Widget> list = List();
    for (String crypto in cryptoList) {
      list.add(Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $crypto = ${data == null ? '?' : data[crypto]} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ));
    }
    return list;
  }
}
