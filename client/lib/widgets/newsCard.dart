import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stock_intrinsic_value_calculator/StockNews.dart';
import 'package:url_launcher/url_launcher.dart';
class NewsCard extends StatelessWidget {

  final StockNews news;

  Future<void> launchUrl(url) async {
    final Uri link = Uri.parse(url);
    if (await canLaunch(link.toString())) {
      await launch(link.toString());
    } else {
      throw Exception('err');
    }
  }

  const NewsCard({Key? key,required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(news.title,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        const SizedBox(height: 5,),
        Text("Date: " + news.date,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        Text("Source: " + news.site,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
        RichText(
            text: TextSpan(
                children: [
                  const TextSpan(text: "Link: ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black)),
                  TextSpan(
                      text: news.url,
                      style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue),
                      recognizer: TapGestureRecognizer()..onTap = () {
                        launchUrl(news.url);
                      },
                  ),
                ],
            ),),
        const Divider(color: Colors.black,),
      ],
    );
  }
}

