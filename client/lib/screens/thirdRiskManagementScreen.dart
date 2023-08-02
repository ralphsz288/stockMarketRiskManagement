import 'package:flutter/material.dart';
import 'package:stock_intrinsic_value_calculator/InsiderTrading.dart';
import 'package:stock_intrinsic_value_calculator/widgets/insiderTradingWidget.dart';

class ThirdRiskManagementScreen extends StatelessWidget {
  final List<InsiderTrading> insiderTradingData;

  const ThirdRiskManagementScreen({Key? key,required this.insiderTradingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15,  right: 30,  left: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Insider trading',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
              Expanded(
                child: ListView.builder(
                  itemCount: insiderTradingData.length,
                  itemBuilder: (BuildContext context, index) {
                    return InsiderTradingWidget(
                      insiderTradingObj: insiderTradingData[index]
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
