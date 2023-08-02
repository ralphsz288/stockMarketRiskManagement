import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stock_intrinsic_value_calculator/PressRelease.dart';

class PressReleaseCard extends StatefulWidget {

  final PressRelease pressRelease;
  const PressReleaseCard({Key? key,required this.pressRelease}) : super(key: key);

  @override
  State<PressReleaseCard> createState() => _PressReleaseCardState();
}

class _PressReleaseCardState extends State<PressReleaseCard> {
  bool isButtonPressed = false;

  void setButtonPressed(bool arg) {
    setState(() {
      isButtonPressed = arg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.pressRelease.title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        Text("Date: " + widget.pressRelease.date,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        if(!isButtonPressed)...[
          RichText(
            text: TextSpan(
              text: 'Read more',
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blue),
              recognizer: TapGestureRecognizer()..onTap = () {
                setButtonPressed(true);
              },
            ),)
        ]else ...[
          RichText(
            text: TextSpan(
              text: 'Hide',
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.blue),
              recognizer: TapGestureRecognizer()..onTap = () {
                setButtonPressed(false);
              },
            ),),
            Text(widget.pressRelease.text),

        ],
        const Divider(color: Colors.black,),
      ],
    );
  }
}
