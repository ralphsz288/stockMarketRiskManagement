import 'dart:convert';

import 'package:flutter/material.dart';
import '../customDrawer.dart';
import '../widgets/customCard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../variables.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  static const storage = FlutterSecureStorage();
  late String token;

  String googleStockPrice = 'Loading...';
  String appleStockPrice = 'Loading...';
  String amazonStockPrice = 'Loading...';
  String intelStockPrice = 'Loading...';

  String googlePriceDifference = '';
  String applePriceDifference = '';
  String amazonPriceDifference = '';
  String intelPriceDifference = '';

  Variables access = Variables();

  void setGoogleStockPrice(String price,String priceDifference) {
    setState(() {
      googleStockPrice = price;
      googlePriceDifference = priceDifference;
    });
  }

  void setAppleStockPrice(String price,String priceDifference) {
    setState(() {
      appleStockPrice = price;
      applePriceDifference = priceDifference;
    });
  }

  void setAmazonStockPrice(String price,String priceDifference) {
    setState(() {
      amazonStockPrice = price;
      amazonPriceDifference = priceDifference;
    });
  }

  void setIntelStockPrice(String price,String priceDifference) {
    setState(() {
      intelStockPrice = price;
      intelPriceDifference = priceDifference;
    });
  }

  @override
  void initState () {
    getPopularStockPrices();
    super.initState();
  }

  getPopularStockPrices () async {
    token = (await storage.read(key: 'token'))!;
    print(token);
    String route = 'http://' + access.access+ ':8000/getPopularStocks/';
    var url = Uri.parse(route);
    http.Response resp = await http.get(url);
    Map data = json.decode(resp.body);
    print(data);
    setGoogleStockPrice(data['googlePrice'].toString(),data['googlePriceDifference'].toString() + ' %');
    setAppleStockPrice(data['applePrice'].toString(),data['applePriceDifference'].toString() + ' %');
    setAmazonStockPrice(data['amazonPrice'].toString(),data['amazonPriceDifference'].toString() + ' %');
    setIntelStockPrice(data['intelPrice'].toString(),data['intelPriceDifference'].toString() + ' %');

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const CustomDrawer(),
      appBar: AppBar(
      ),
      body:
        RefreshIndicator(
          onRefresh: () async {
            await  getPopularStockPrices();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 0, 20),
                    child: Text('Popular now',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  ),
                  CustomCard(photo: "images/googleIcon2.png",companyName: 'Alphabet (Class A)',tickerSymbol: 'GOOGL',stockPrice: googleStockPrice,stockPriceDifference: googlePriceDifference,),
                  CustomCard(photo:"images/appleIcon2.png",companyName: 'Apple',tickerSymbol: 'AAPL',stockPrice: appleStockPrice,stockPriceDifference: applePriceDifference,),
                  CustomCard(photo:"images/amazonLogo.png",companyName: 'Amazon',tickerSymbol: 'AMZN',stockPrice: amazonStockPrice,stockPriceDifference: amazonPriceDifference,),
                  CustomCard(photo: "images/intelLogo.jpg",companyName: 'Intel',tickerSymbol: 'INTC',stockPrice: intelStockPrice,stockPriceDifference: intelPriceDifference,),


                ],
              ),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed : () {Navigator.pushNamed(context, '/riskManagement');},
          label: const Text('Risk management')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}