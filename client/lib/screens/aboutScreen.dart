import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Documentation',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.black)),
              SizedBox(height: 15,),
              Text('1.Discounted Cash Flow:',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
              Text('Discounted cash flow (DCF) is a financial valuation method used to estimate the '
                  'intrinsic value of an investment or business by calculating the present value of its '
                  'expected future cash flows. It involves forecasting the future cash flows and then '
                  'discounting them back to their present value using a discount rate that reflects the time value '
                  'of money and the risk associated with the investment. By discounting the cash flows, '
                  'DCF accounts for the fact that money received in the future is worth less than the same '
                  'amount of money received today. The DCF analysis helps in assessing whether an investment or '
                  'business is potentially undervalued or overvalued.',style:const TextStyle(fontSize: 10,color: Colors.black) ,),
              SizedBox(height: 15,),
              Text('2.Sharpe ratio:',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
              Text('The Sharpe ratio provides a way to compare the risk-adjusted returns of different investments or portfolios. A higher Sharpe ratio indicates a better risk-adjusted performance, as it implies a higher return relative to the level of risk taken. Conversely, a lower Sharpe ratio suggests lower returns or higher volatility for the same level of '
                  'risk.',style: const TextStyle(fontSize: 10),),
              SizedBox(height: 15,),
              Text('2.Sortino ratio:',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
              Text('Similar to the Sharpe ratio, the Sortino ratio assumes that investment returns follow a normal distribution. However, '
                  'it places more emphasis on protecting against downside risk rather '
                  'than overall volatility.',style: const TextStyle(fontSize: 10),),
              SizedBox(height: 15,),
              Text('3.Beta:',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
              Text(
                'Beta is a measure of a stock\'s or investment\'s sensitivity to movements in the overall market. It quantifies the degree to which the price of a security tends to move in relation to changes in a benchmark index, typically the market as a whole, such as the S&P 500.\n\nA beta of 1 indicates that the stock tends to move in sync with the market.',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 15,),
              Text('4.Value at risk:',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
              Text(
                'Value at Risk (VaR) is a statistical measure used in risk management to estimate the potential loss of an investment, at a given confidence level. It provides an estimate of the maximum loss that an investment could incur under normal market conditions.',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 15,),
              Text('5.Annualized volatility:',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.black)),
              Text(
                'Annualized volatility is a measure of the standard deviation of an investment\'s returns over a specific periodIt quantifies the degree of price fluctuation or volatility experienced by the investment on an annualized basis.',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 15,),
              Text('All data used in this application was provided by Financial Modeling Prep. '),

            ],
          ),
        ),
      ),

    );
  }
}
