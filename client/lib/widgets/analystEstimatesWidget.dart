import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnalystEstimatesWidget extends StatelessWidget {
  final String type;
  final double estimatedValue;
  final double actualValue;
  const AnalystEstimatesWidget({Key? key,required this.type, required this.estimatedValue,required this.actualValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Reported " + type + ': ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)),
              TextSpan(text: actualValue.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "Estimated " + type + ': ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)),
              TextSpan(text: estimatedValue.toString(),style: (estimatedValue < actualValue) ? const TextStyle(fontSize: 15, color: Colors.red) : const TextStyle(fontSize: 15, color: Colors.lightGreen)),
            ],
          ),
        ),
      ],
    );
  }
}
