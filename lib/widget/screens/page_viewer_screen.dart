import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

class PageViewerScreen extends StatefulWidget {
  final int chapterID;
  final String chapterName;

  const PageViewerScreen(
      {Key? key, required this.chapterID, required this.chapterName})
      : super(key: key);

  @override
  _PageViewerScreenState createState() => _PageViewerScreenState();
}

class _PageViewerScreenState extends State<PageViewerScreen> {
  double _page = 0;
  CarouselController _carouselController = CarouselController();
  List<String> pageList = [];

  @override
  void initState() {
    super.initState();
    loadChapters();
  }

  void loadChapters() async {
    String result = await http.read(Uri.parse(
        "https://tsukimangas.com/api/v2/chapter/versions/${widget.chapterID}"));
    Map resultJSON = json.decode(result);
    List<String> pageListRaw = [];
    var response = await http.get(Uri.parse(
        "https://cdn2.tsukimangas.com${resultJSON['pages'][0]['url']}"));
    String cdn = response.statusCode == 404 ? "cdn1" : "cdn2";
    for (Map page in resultJSON['pages']) {
      pageListRaw.add("https://$cdn.tsukimangas.com${page['url']}");
    }
    setState(() {
      pageList = pageListRaw;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.grey[850],
          title: Text("Capítulo ${widget.chapterName}",
              style: TextStyle(color: Colors.white)),
        ),
        body: CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
              onPageChanged: (pageNumber, _) {
                setState(() {
                  _page = pageNumber.toDouble();
                });
              },
              height: height,
              reverse: true,
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
                      child: CachedNetworkImage(
                        imageUrl: index,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: height,
                      ),
                    ));
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.grey[850],
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Container(
                  height: 20,
                  child: Slider(
                      max: pageList.length.toDouble(),
                      min: 0,
                      value: _page,
                      divisions: pageList.length == 0 ? 1 : pageList.length,
                      onChanged: (value) {
                        setState(() {
                          _page = value;
                          _carouselController.animateToPage(value.toInt());
                        });
                      }),
                ))));
  }
}
