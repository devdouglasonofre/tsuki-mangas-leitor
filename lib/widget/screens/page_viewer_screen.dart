import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PageViewerScreen extends StatefulWidget {
  final int chapterID;

  const PageViewerScreen({Key? key, required this.chapterID}) : super(key: key);

  @override
  _PageViewerScreenState createState() => _PageViewerScreenState();
}

class _PageViewerScreenState extends State<PageViewerScreen> {
  List<String> pageList = [];

  @override
  void initState() {
    loadChapters();
    super.initState();
  }

  void loadChapters() async {
    String result = await http.read(Uri.parse(
        "https://tsukimangas.com/api/v2/chapter/versions/${widget.chapterID}"));
    Map resultJSON = json.decode(result);
    List<String> pageListRaw = [];
    for (Map page in resultJSON['pages']) {
      pageListRaw.add(page['url']);
    }
    print(pageListRaw);
    setState(() {
      pageList = pageListRaw;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: CarouselSlider(
      options: CarouselOptions(
          height: height,
          enlargeCenterPage: false,
          autoPlay: false,
          viewportFraction: 1.0,
          enableInfiniteScroll: false),
      items: pageList.map((index) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                height: height,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Center(
                  child: Image(
                    image: NetworkImage("https://cdn1.tsukimangas.com/$index"),
                    height: height,
                  ),
                ));
          },
        );
      }).toList(),
    ));
  }
}
