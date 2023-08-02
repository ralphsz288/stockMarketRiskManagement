import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stock_intrinsic_value_calculator/PressRelease.dart';
import 'package:stock_intrinsic_value_calculator/widgets/analystGradesWidget.dart';
import 'package:stock_intrinsic_value_calculator/widgets/newsCard.dart';
import 'package:stock_intrinsic_value_calculator/widgets/pressReleaseCard.dart';

import 'package:stock_intrinsic_value_calculator/widgets/analystEstimatesWidget.dart';

class SecondRiskManagementScreen extends StatefulWidget {
  final Map pressReleaseData;
  final Map analystEstimatesData;
  final List newsData;
  const SecondRiskManagementScreen({Key? key,required this.pressReleaseData,required this.analystEstimatesData,required this.newsData}) : super(key: key);

  @override
  State<SecondRiskManagementScreen> createState() => _SecondRiskManagementScreenState();
}

class _SecondRiskManagementScreenState extends State<SecondRiskManagementScreen> {

  bool isButtonPressed = false;

  void setButtonPressed(bool arg) {
    setState(() {
      isButtonPressed = arg;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15,  right: 30,  left: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Press releases',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                const Divider(color: Colors.black,),
                PressReleaseCard(pressRelease: PressRelease(widget.pressReleaseData['pressRelease1']['date'],widget.pressReleaseData['pressRelease1']['title'],widget.pressReleaseData['pressRelease1']['text'],)),
                PressReleaseCard(pressRelease: PressRelease(widget.pressReleaseData['pressRelease2']['date'],widget.pressReleaseData['pressRelease2']['title'],widget.pressReleaseData['pressRelease2']['text'],)),
                PressReleaseCard(pressRelease: PressRelease(widget.pressReleaseData['pressRelease3']['date'],widget.pressReleaseData['pressRelease3']['title'],widget.pressReleaseData['pressRelease3']['text'],)),
                const SizedBox(height:10),
                const Text('Latest news',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                const Divider(color: Colors.black,),
                NewsCard(news: widget.newsData[0]),
                NewsCard(news: widget.newsData[1]),
                NewsCard(news: widget.newsData[2]),
                if(!isButtonPressed)...[
                  const Text('Analyst estimates',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                  const SizedBox(height: 5,),
                  Text('Report date: ' + widget.analystEstimatesData['date']['report'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                  Text('Estimations date: ' + widget.analystEstimatesData['date']['estimations'],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                  AnalystEstimatesWidget(type : 'revenue', estimatedValue: widget.analystEstimatesData['revenue']['estimated'].toDouble(), actualValue: widget.analystEstimatesData['revenue']['actual'].toDouble(),),
                  AnalystEstimatesWidget(type : 'ebitda', estimatedValue: widget.analystEstimatesData['ebitda']['estimated'].toDouble(), actualValue: widget.analystEstimatesData['ebitda']['actual'].toDouble(),),
                  AnalystEstimatesWidget(type : 'net income', estimatedValue: widget.analystEstimatesData['netIncome']['estimated'].toDouble(), actualValue: widget.analystEstimatesData['netIncome']['actual'].toDouble(),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5,),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "Reported eps: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)),
                            TextSpan(text: widget.analystEstimatesData['eps']['actual'].toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "Estimated eps: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)),
                            TextSpan(text: widget.analystEstimatesData['eps']['estimated'].toString(),style: (widget.analystEstimatesData['eps']['estimated'] < widget.analystEstimatesData['eps']['actual']) ? const TextStyle(fontSize: 15, color: Colors.red) : const TextStyle(fontSize: 15, color: Colors.lightGreen)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5,),
                      RichText(
                        text: TextSpan(
                          text: 'See analyst grades',
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blue),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            setButtonPressed(true);
                          },
                        ),),
                    ],
                  ),
                ]else...[
                  const Text('Analyst grades',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                  AnalystGrades(gradingCompany: widget.analystEstimatesData['grade1']['gradingCompany'], newGrade: widget.analystEstimatesData['grade1']['newGrade'], previousGrade: widget.analystEstimatesData['grade1']['previousGrade'], date: widget.analystEstimatesData['grade1']['date']),
                  AnalystGrades(gradingCompany: widget.analystEstimatesData['grade2']['gradingCompany'], newGrade: widget.analystEstimatesData['grade2']['newGrade'], previousGrade: widget.analystEstimatesData['grade2']['previousGrade'], date: widget.analystEstimatesData['grade2']['date']),
                  AnalystGrades(gradingCompany: widget.analystEstimatesData['grade3']['gradingCompany'], newGrade: widget.analystEstimatesData['grade3']['newGrade'], previousGrade: widget.analystEstimatesData['grade3']['previousGrade'], date: widget.analystEstimatesData['grade3']['date']),
                  AnalystGrades(gradingCompany: widget.analystEstimatesData['grade4']['gradingCompany'], newGrade: widget.analystEstimatesData['grade4']['newGrade'], previousGrade: widget.analystEstimatesData['grade4']['previousGrade'], date: widget.analystEstimatesData['grade4']['date']),
                  AnalystGrades(gradingCompany: widget.analystEstimatesData['grade5']['gradingCompany'], newGrade: widget.analystEstimatesData['grade5']['newGrade'], previousGrade: widget.analystEstimatesData['grade5']['previousGrade'], date: widget.analystEstimatesData['grade5']['date']),
                  SizedBox(height: 5,),
                  RichText(
                    text: TextSpan(
                      text: 'See analyst estimates',
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        setButtonPressed(false);
                      },
                    ),),
                ],
                const SizedBox(height: 50,),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
