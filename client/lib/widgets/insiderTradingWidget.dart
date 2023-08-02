import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stock_intrinsic_value_calculator/InsiderTrading.dart';
import 'package:url_launcher/url_launcher.dart';

class InsiderTradingWidget extends StatelessWidget {

  final InsiderTrading insiderTradingObj;
  Future<void> launchUrl(url) async {
    final Uri link = Uri.parse(url);
    if (await canLaunch(link.toString())) {
      await launch(link.toString());
    } else {
      throw Exception('err');
    }
  }

  const InsiderTradingWidget({Key? key,required this.insiderTradingObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Date: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(text: insiderTradingObj.date,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Name: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(text: insiderTradingObj.name+ ' (' + insiderTradingObj.position + ')',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Transaction type: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(text: insiderTradingObj.type,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Security name: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(text: insiderTradingObj.securityName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Acquisition or Disposition: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(text: insiderTradingObj.acquisitionOrDisposition,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Securities transacted: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(text: insiderTradingObj.securitiesTransacted.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Price: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(text: insiderTradingObj.price,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(text: "Link: ",style: TextStyle(fontSize: 15,color: Colors.black)),
              TextSpan(
                text: insiderTradingObj.url,
                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue),
                recognizer: TapGestureRecognizer()..onTap = () {
                  launchUrl(insiderTradingObj.url);
                },
              ),
            ],
          ),),
        Divider(color: Colors.black),

      ],
    );
  }
}
