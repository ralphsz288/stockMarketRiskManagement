import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String photo;
  final String companyName;
  final String tickerSymbol;
  final String stockPrice;
  final String stockPriceDifference;

  const CustomCard({Key? key,required this.photo,required this.companyName,required this.tickerSymbol,required this.stockPrice,required this.stockPriceDifference}) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: Card(
        shadowColor: Colors.blue,
        elevation: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  height: 50,
                  width: 75,
                  child: Image.asset(widget.photo)),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.companyName,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                    Text(widget.tickerSymbol,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),)
                  ],
                ),
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.stockPrice,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                  Text(widget.stockPriceDifference, style: (widget.stockPriceDifference != '' &&  widget.stockPriceDifference[0] == '-' ) ? const TextStyle(fontSize: 13, color: Colors.red) : const TextStyle(fontSize: 13, color: Colors.lightGreen) ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
