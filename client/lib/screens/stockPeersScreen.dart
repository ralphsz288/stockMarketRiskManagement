import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_intrinsic_value_calculator/screens/compareResultsScreen.dart';
import '../variables.dart';
import 'package:http/http.dart' as http;

class StockPeersScreen extends StatefulWidget {
  final Map stockPeers;
  final Map mainCompany;

  const StockPeersScreen({Key? key, required this.stockPeers, required this.mainCompany})
      : super(key: key);

  @override
  State<StockPeersScreen> createState() => _StockPeersScreenState();
}

class _StockPeersScreenState extends State<StockPeersScreen> {
  List<bool>? _checkedItems;
  String tickerSymbol = '';
  bool isDoubleItem = false;
  final Variables access = Variables();

  @override
  void initState() {
    super.initState();
    _checkedItems = List<bool>.generate(widget.stockPeers['data'].length, (index) => false);
  }

  void setTickerSymbol(String ticker) {
    setState(() {
      tickerSymbol = ticker.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 15,
              right: 30,
              left: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Text(
                  'Stock peers of ' + widget.mainCompany['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 400,
                  child: ListView.builder(
                    itemCount: widget.stockPeers['data'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return CheckboxListTile(
                        value: _checkedItems?[index] ?? false,
                        onChanged: (bool? value) {
                          setState(() {
                            _checkedItems?[index] = value ?? false;
                          });
                        },
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                        title: Text(widget.stockPeers['data'][index]['name']),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12, bottom: 35, top: 20),
                  child: Form(
                    child: TextFormField(

                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            if (tickerSymbol != '') {
                              for (var stock in widget.stockPeers['data']) {
                                print(stock['ticker']);
                                if (stock['ticker'] == tickerSymbol) {
                                  showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Alert'),
                                    content: const Text('The company you selected is already part of the list'),
                                    actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                      Navigator.of(context).pop();
                                    } )],
                                  ),
                                  );
                                  setState(() {
                                    isDoubleItem = true;
                                  });
                                  break;
                                }
                              }
                                if (!isDoubleItem){
                                  showDialog(context: context, builder: (context) {
                                    return const Center(child: CircularProgressIndicator());
                                  });
                                  final companyNameRoute = 'http://' + access.access+ ':8000/getCompanyNameUsingTicker/?companyTicker=$tickerSymbol';
                                  final companyNameUrl = Uri.parse(companyNameRoute);
                                  http.Response companyNameResp = await http.get(companyNameUrl);
                                  Navigator.of(context).pop();
                                  Map companyNameData = json.decode(companyNameResp.body);
                                  print(companyNameData);
                                  if ( companyNameData['success']) {
                                    setState(() {
                                      widget.stockPeers['data'].insert(0,
                                          {
                                            'name': companyNameData['name'],
                                            'ticker': tickerSymbol,
                                            'marketCap' : companyNameData['mktCap'],
                                            'price' : companyNameData['price'],
                                            'volAvg' : companyNameData['volAvg'],
                                            'range' : companyNameData['range'],
                                            'sector' : companyNameData['sector'],
                                          });
                                      _checkedItems?.insert(0,true);
                                    });
                                  }else{
                                    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Alert'),
                                      content: const Text('The company you selected can not be found'),
                                      actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                        Navigator.of(context).pop();
                                      } )],
                                    ),
                                    );
                                  }
                                }
                            } else {
                              showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                                title: const Text('Alert'),
                                content: const Text('Please enter a value'),
                                actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                                  Navigator.of(context).pop();
                                } )],
                              ),
                              );
                            }
                          },
                        ),
                        labelText: 'Add company',
                        hintText: 'Enter company ticker',
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setTickerSymbol(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      List selectedItems = [];
                      for (int i=0; i<_checkedItems!.length;i++) {
                        if(_checkedItems![i] == true){
                          selectedItems.add(widget.stockPeers['data'][i]);
                        }
                      }
                      if(selectedItems.length != 0) {

                        showDialog(context: context, builder: (context) {
                          return const Center(child: CircularProgressIndicator());
                        });
                        final mainTicker = widget.mainCompany['ticker'];
                        final mainCompanyKeyMetricsRoute = 'http://' + access.access+ ':8000/getCompanyKeyMetrics/?companyTicker=$mainTicker';
                        final mainCompanyKeyMetrics = Uri.parse(mainCompanyKeyMetricsRoute);
                        http.Response mainCompanyKeyMetricsResp = await http.get(mainCompanyKeyMetrics);

                        Map mainCompanyKeyMetricsData = json.decode(mainCompanyKeyMetricsResp.body);
                        widget.mainCompany['eps'] = mainCompanyKeyMetricsData['eps'];
                        widget.mainCompany['netIncome'] = mainCompanyKeyMetricsData['netIncome'];
                        widget.mainCompany['revenue'] = mainCompanyKeyMetricsData['revenue'];
                        widget.mainCompany['grossProfitRatio'] = mainCompanyKeyMetricsData['grossProfitRatio'];
                        widget.mainCompany['peRatio'] = mainCompanyKeyMetricsData['peRatio'];
                        widget.mainCompany['dividend'] = mainCompanyKeyMetricsData['dividend'];
                        print(widget.mainCompany);
                        print(widget.mainCompany.runtimeType);

                        for(int i=0; i<selectedItems.length;i++){
                          var firstSelectedItemsTicker = selectedItems[i]['ticker'];
                          print(firstSelectedItemsTicker);
                          final firstSelectedItemKeyMetricsRoute = 'http://' + access.access+ ':8000/getCompanyKeyMetrics/?companyTicker=$firstSelectedItemsTicker';
                          final firstSelectedItemKeyMetrics = Uri.parse(firstSelectedItemKeyMetricsRoute);
                          http.Response firstSelectedItemKeyMetricsResp = await http.get(firstSelectedItemKeyMetrics);

                          Map firstSelectedItemKeyMetricRespKeyMetricsData = json.decode(firstSelectedItemKeyMetricsResp.body);
                          print(firstSelectedItemKeyMetricRespKeyMetricsData);

                          selectedItems[i]['eps'] = firstSelectedItemKeyMetricRespKeyMetricsData['eps'];
                          selectedItems[i]['netIncome'] = firstSelectedItemKeyMetricRespKeyMetricsData['netIncome'];
                          selectedItems[i]['revenue'] = firstSelectedItemKeyMetricRespKeyMetricsData['revenue'];
                          selectedItems[i]['grossProfitRatio'] = firstSelectedItemKeyMetricRespKeyMetricsData['grossProfitRatio'];
                          selectedItems[i]['peRatio'] = firstSelectedItemKeyMetricRespKeyMetricsData['peRatio'];
                          selectedItems[i]['dividend'] = firstSelectedItemKeyMetricRespKeyMetricsData['dividend'];
                        }
                        print(selectedItems.length);


                        print(selectedItems);

                        Navigator.of(context).pop();
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompareResultsScreen(selectedItems: selectedItems,mainItem: widget.mainCompany,),
                          ),
                        );
                      }else{
                        showDialog(context: context, builder: (BuildContext context) => AlertDialog(
                          title: const Text('Alert'),
                          content: const Text('Please select a company from the list'),
                          actions:<Widget> [TextButton(child: const Text('Ok'),onPressed: () {
                            Navigator.of(context).pop();
                          } )],
                        ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    child: const Text('Compare', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
