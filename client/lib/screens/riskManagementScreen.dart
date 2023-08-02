import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_intrinsic_value_calculator/InsiderTrading.dart';
import 'package:stock_intrinsic_value_calculator/screens/stockPeersScreen.dart';
import 'package:stock_intrinsic_value_calculator/screens/thirdRiskManagementScreen.dart';
import 'package:stock_intrinsic_value_calculator/widgets/newsCard.dart';
import 'package:stock_intrinsic_value_calculator/screens/secondRiskManagementScreen.dart';
import 'package:stock_intrinsic_value_calculator/widgets/numberOfSharesWidget.dart';
import '../variables.dart';
import '../StockNews.dart';

class RiskManagementScreen extends StatefulWidget {
  const RiskManagementScreen({Key? key}) : super(key: key);

  @override
  State<RiskManagementScreen> createState() => _RiskManagementScreenState();
}

class _RiskManagementScreenState extends State<RiskManagementScreen> {

  late String tickerSymbol;
  bool buttonPressed = false;
  String menuValue = '5year average free cash flow growth rate';
  String secondValue = '';
  var items = ['5year average free cash flow growth rate','5year average free cash flow growth rate/2'];

  late String companyName;
  late String growthValueUsed;
  late String fairValue;
  late String currentPrice ;
  late Map numberOfShares;
  late Map valueAtRisk;
  List<InsiderTrading> insiderTradingObjects = [];

  late StockNews news1;
  late StockNews news2;
  late StockNews news3;
  final Variables access = Variables();


  void setTickerSymbol(String ticker) {
    setState(() {
      tickerSymbol = ticker;
    });
  }

  void setButtonPressed(bool isButtonPressed) {
    setState(() {
      buttonPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Risk management'),
        actions: [
          if(buttonPressed) ...[
            IconButton(
            icon: const Icon(
            Icons.newspaper,
              color: Colors.white,
            ),
            onPressed: () async {
              showDialog(context: context, builder: (context) {
                return const Center(child: CircularProgressIndicator());
              });

              final route = 'http://' + access.access+ ':8000/getStockPressRelease/?companyTicker=$tickerSymbol';
              final url = Uri.parse(route);
              http.Response resp = await http.get(url);

              final analystEstimatesRoute = 'http://' + access.access+ ':8000/getAnalystEstimates/?companyTicker=$tickerSymbol';
              final analystEstimatesUrl = Uri.parse(analystEstimatesRoute);
              http.Response response = await http.get(analystEstimatesUrl);

              var newsRoute = 'http://' + access.access+ ':8000/getStockNews/?companyTicker=$tickerSymbol';
              var newsUrl = Uri.parse(newsRoute);
              http.Response newsResp = await http.get(newsUrl);
              Map newsData = json.decode(newsResp.body);
              news1 = StockNews(newsData['news1']['date'],newsData['news1']['title'],newsData['news1']['site'],newsData['news1']['url']);
              news2 = StockNews(newsData['news2']['date'],newsData['news2']['title'],newsData['news2']['site'],newsData['news2']['url']);
              news3 = StockNews(newsData['news3']['date'],newsData['news3']['title'],newsData['news3']['site'],newsData['news3']['url']);
              final newsObjects = [news1,news2,news3];
              Navigator.of(context).pop();
              Map data = json.decode(resp.body);
              Map analystEstimatesData = json.decode(response.body);
              print(analystEstimatesData);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondRiskManagementScreen(pressReleaseData: data, analystEstimatesData: analystEstimatesData,newsData: newsObjects,),
                ),
              );
            },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline,color: Colors.white,),
              onPressed: () async {
                showDialog(context: context, builder: (context) {
                  return const Center(child: CircularProgressIndicator());
                });
                final route = 'http://' + access.access+ ':8000/getCompanyInsiderTrading/?companyTicker=$tickerSymbol';
                final url = Uri.parse(route);
                http.Response resp = await http.get(url);
                Map companyInsiderTradingData = json.decode(resp.body);

                for (int i = 0; i < companyInsiderTradingData['data'].length; i++){
                  var listObj = companyInsiderTradingData['data'][i];
                  print(listObj['price'].runtimeType);

                  insiderTradingObjects.add(
                      InsiderTrading(
                          listObj['date'],
                          listObj['type'],
                          listObj['name'],
                          listObj['position'],
                          listObj['acquisitionOrDisposition'],
                          listObj['securitiesTransacted'],
                          listObj['securityName'],
                          listObj['price'].toString(),
                          listObj['link'],
                      ));
                }
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThirdRiskManagementScreen(insiderTradingData: insiderTradingObjects),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.compare_arrows,color: Colors.white,),
              onPressed: () async {
                showDialog(context: context, builder: (context) {
                  return const Center(child: CircularProgressIndicator());
                });
                final route = 'http://' + access.access+ ':8000/getStockPeers/?companyTicker=$tickerSymbol';
                final url = Uri.parse(route);
                http.Response resp = await http.get(url);
                Map stockPeersData = json.decode(resp.body);
                print(stockPeersData['mainCompany'].runtimeType);
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockPeersScreen(stockPeers: stockPeersData,mainCompany: stockPeersData['mainCompany'],),
                  ),
                );
              },
            ),
          ],
      ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 30,  right: 30,  left: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(buttonPressed) ...[
                  Container(
                    width: 600,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue
                      )
                    ),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(companyName,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.blue),),
                            Text('Current price: ' + currentPrice + ' \$',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            Text('Fair value: ' + fairValue + ' \$',style: (double.parse(fairValue) >= double.parse(currentPrice)) ? const TextStyle(fontSize: 20, color: Colors.lightGreen,fontWeight: FontWeight.bold) : const TextStyle(fontSize: 20, color: Colors.red,fontWeight: FontWeight.bold) ),
                            Text('Growth average used: ' + (double.parse(growthValueUsed) *100).toString() + '%',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Value at risk',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                      const Divider(color: Colors.black,),
                      Text('VaR: ' +valueAtRisk['data2'].toString()),
                      Text('Changes since ' + valueAtRisk['firstDay'] + ': ',style: const TextStyle(fontWeight: FontWeight.bold),),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "Highest growth: ",style: TextStyle(fontSize: 15,color: Colors.black)),
                            TextSpan(
                              text: valueAtRisk['maxChange']['value'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.green),
                            ),
                            TextSpan(text: "% (" + valueAtRisk['maxChange']['date'] + ')' ,style: const TextStyle(fontSize: 15,color: Colors.black)),
                          ],
                        ),),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "Highest decline: ",style: TextStyle(fontSize: 15,color: Colors.black)),
                            TextSpan(
                              text: valueAtRisk['minChange']['value'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.red),
                            ),
                            TextSpan(text: "% (" + valueAtRisk['minChange']['date'] + ')' ,style: const TextStyle(fontSize: 15,color: Colors.black)),
                          ],
                        ),),
                      const SizedBox(height: 5,),
                      const Text('Volatilty',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                      const Divider(color: Colors.black,),
                      Text('Anualized volatilty: ' +valueAtRisk['vol'].toString()),
                      Text('Sharpe ratio: ' +valueAtRisk['sharpe'].toString()),
                      Text('Sortino ratio: ' +valueAtRisk['sortino'].toString()),
                      Text('Beta: ' +valueAtRisk['beta'].toString()),
                      const SizedBox(height: 5,),
                      const Divider(color: Colors.black,),
                      const Text('Historical number of shares',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                      const Divider(color: Colors.black,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            NumberOfSharesWidget(shares: numberOfShares['data'][0]['numberOfShares'], date: numberOfShares['data'][0]['date'], customColor: numberOfShares['data'][0]['numberOfShares'] >
                                numberOfShares['data'][4]['numberOfShares']
                                ? Colors.red
                                : Colors.green, ),
                            const SizedBox(width: 10,),
                            NumberOfSharesWidget(shares: numberOfShares['data'][1]['numberOfShares'], date: numberOfShares['data'][1]['date'],customColor: Colors.black,),
                            const SizedBox(width: 10,),
                            NumberOfSharesWidget(shares: numberOfShares['data'][2]['numberOfShares'], date: numberOfShares['data'][2]['date'],customColor: Colors.black,),
                            const SizedBox(width: 10,),
                            NumberOfSharesWidget(shares: numberOfShares['data'][3]['numberOfShares'], date: numberOfShares['data'][3]['date'],customColor: Colors.black,),
                            const SizedBox(width: 10,),
                            NumberOfSharesWidget(shares: numberOfShares['data'][4]['numberOfShares'], date: numberOfShares['data'][4]['date'],customColor: Colors.black,),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.black,),
                      const SizedBox(height: 5,),
                      if(numberOfShares['percentage'] > 0) ... [
                        Text('There was a share buyback of ' + numberOfShares['percentage'].toString() + '% since ' +numberOfShares['data'][4]['date'],style: const TextStyle(fontSize: 12),),
                      ]else ... [
                        Text('The company issued ' + (-1 * numberOfShares['percentage']).toString() + '% more shares since '  + numberOfShares['data'][4]['date'],style: const TextStyle(fontSize: 12),),
                      ],
                    ],
                  ),
                  const SizedBox(height: 50,),
                ]else ... [
                Form(
                  child: TextFormField(
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      labelText: 'Ticker Symbol',
                      hintText: 'Enter company ticker symbol',
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                      border:OutlineInputBorder()
                  ),
                  onChanged: (value){
                    setTickerSymbol(value);
                  },
                  validator: (value){
                    return value!.isEmpty ? 'Please enter username' : 'usr';
                  },
                ),),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Choose cash flow growth rate',style: TextStyle(fontWeight: FontWeight.w500),),
                ),
                DropdownButton(
                    value: menuValue,
                    isExpanded: true,
                    items: items.map((String items){
                      return DropdownMenuItem(
                          value: items,
                          child: Text(items),);
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        menuValue = newValue!;
                      });
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('or',style: TextStyle(fontWeight: FontWeight.w500),),
                ),
                Form(
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        labelText: 'Enter it yourself',
                        hintText: 'ex: 0.10 for 10%',
                        prefixIcon: Icon(Icons.monetization_on_outlined),
                        border:OutlineInputBorder()
                    ),
                    onChanged: (String? value){
                      setState(() {
                        secondValue = value!;
                      });
                    },
                    validator: (value){
                      return value!.isEmpty ? 'Please enter username' : 'usr';
                    },
                  ),),
              ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed : () async {
            String requestValue;
            if (secondValue.isNotEmpty) {
              requestValue = secondValue;
            }else{
              requestValue = menuValue;
            }
            setTickerSymbol(tickerSymbol.toUpperCase());
            showDialog(context: context, builder: (context) {
              return const Center(child: CircularProgressIndicator());
            });
            final route = 'http://' + access.access+ ':8000/getFreeCashFlow/?companyTicker=$tickerSymbol&growthAverage=$requestValue';
            final url = Uri.parse(route);
            http.Response resp = await http.get(url);

            final sharesOutRoute = 'http://' + access.access+ ':8000/getStockNumberOfShares/?companyTicker=$tickerSymbol';
            final sharesOutUrl = Uri.parse(sharesOutRoute);
            http.Response sharesOutResp = await http.get(sharesOutUrl);

            final valueAtRiskRoute = 'http://' + access.access+ ':8000/getValueAtRiskAndVolatilty/?companyTicker=$tickerSymbol';
            final valueAtRiskUrl = Uri.parse(valueAtRiskRoute);
            http.Response valueAtRiskResp = await http.get(valueAtRiskUrl);

            Navigator.of(context).pop();
            Map data = json.decode(resp.body);
            Map sharesOutData = json.decode(sharesOutResp.body);
            Map valueAtRiskData = json.decode(valueAtRiskResp.body);
            if(!data['succes']){
              showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                title: const Text('Alert'),
                content: Text(data['message']),
                actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                  Navigator.of(context).pop();
                } )],
              ),
              );
            }else{
              print(data);
              setState(() {
                companyName = data['companyName'];
                currentPrice = data['currentPrice'].toString();
                growthValueUsed = data['growthAverage'].toString();
                fairValue = data['fairValue'].toString();
                numberOfShares = sharesOutData;
                valueAtRisk = valueAtRiskData;

              });
              setButtonPressed(true);
            }
          },
          label: const Text('Calculate')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
