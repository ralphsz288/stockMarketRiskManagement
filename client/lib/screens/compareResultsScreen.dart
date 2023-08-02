import 'package:flutter/material.dart';

class CompareResultsScreen extends StatefulWidget {
  final List selectedItems;
  final Map mainItem;
  const CompareResultsScreen({required this.selectedItems,required this.mainItem,Key? key}) : super(key: key);

  @override
  State<CompareResultsScreen> createState() => _CompareResultsScreenState();
}

class _CompareResultsScreenState extends State<CompareResultsScreen> {

  int position = 0;

  void setPosition(int val , List array,) {
    setState(() {
      if(position + val == array.length){
        position = 0;
      }else if(position + val == -1) {
        position = array.length - 1;
      }else{
        position = position + val;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.mainItem['ticker'],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    Text(widget.mainItem['name']),
                    const SizedBox(height: 10,),
                    Text('Price: ' + widget.mainItem['price'].toString()),
                    const SizedBox(height: 10,),
                    Text('P/E ratio: ' + widget.mainItem['peRatio'].toString()),
                    const SizedBox(height: 10,),
                    Text('Eps: ' + widget.mainItem['eps'].toString()),
                    const SizedBox(height: 10,),
                    Text('Profit ratio: ' + widget.mainItem['grossProfitRatio'].toString()),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Market cap:'),
                          Text(widget.mainItem['mktCap'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Net income:'),
                          Text(widget.mainItem['netIncome'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Revenue:'),
                          Text(widget.mainItem['revenue'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Volume average:'),
                          Text(widget.mainItem['volAvg'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Range:'),
                          Text(widget.mainItem['range'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 75,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Sector:'),
                          Text(widget.mainItem['sector'].toString()),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.selectedItems[position]['ticker'],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                    const SizedBox(height: 10,),
                    Text(widget.selectedItems[position]['name'],overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10,),
                    Text('Price: ' + widget.selectedItems[position]['price'].toString()),
                    const SizedBox(height: 10,),
                    Text('P/E ratio: ' + widget.selectedItems[position]['peRatio'].toString()),
                    const SizedBox(height: 10,),
                    Text('Eps: ' + widget.selectedItems[position]['eps'].toString()),
                    const SizedBox(height: 10,),
                    Text('Profit ratio: ' + widget.selectedItems[position]['grossProfitRatio'].toString()),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Market cap:'),
                          Text(widget.selectedItems[position]['marketCap'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Net income:'),
                          Text(widget.selectedItems[position]['netIncome'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Revenue:'),
                          Text(widget.selectedItems[position]['revenue'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Volume average:'),
                          Text(widget.selectedItems[position]['volAvg'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Range:'),
                          Text(widget.selectedItems[position]['range'].toString()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      height: 75,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: Column(
                        children: [
                          const Text('Sector:'),
                          Text(widget.selectedItems[position]['sector'].toString()),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.blue,
                          onPressed: () {
                            setPosition(-1, widget.selectedItems);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          color: Colors.blue,
                          onPressed: () {
                            setPosition(1, widget.selectedItems);
                          },
                        ),
                      ],
                    ),


                  ],

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
