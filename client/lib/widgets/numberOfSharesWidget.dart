import 'package:flutter/material.dart';

class NumberOfSharesWidget extends StatelessWidget {
  final String date;
  final int shares;
  final Color customColor;
  const NumberOfSharesWidget({Key? key,required this.shares,required this.date,required this.customColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
        Text(shares.toString(),style: TextStyle(fontSize: 15,color: customColor),),
        const SizedBox(width: 5,),
      ],
    );
  }
}
