import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:tsuki/widget/screens/page_viewer_screen.dart';

class ChapterListWidget extends StatefulWidget {
  final int mangaID;

  const ChapterListWidget({Key? key, required this.mangaID}) : super(key: key);

  @override
  _ChapterListWidgetState createState() => _ChapterListWidgetState();
}

class _ChapterListWidgetState extends State<ChapterListWidget> {
  List<Map<dynamic, dynamic>> chapterList = [];
  int page = 1;

  @override
  void initState() {
    loadChapters();
    super.initState();
  }

  void loadChapters() async {
    String result = await http.read(Uri.parse(
        "https://tsukimangas.com/api/v2/chapters?manga_id=${widget.mangaID}&order=desc&page=${page}"));
    Map resultJSON = json.decode(result);
    List<Map> chapterListRaw = [];
    for (Map chapter in resultJSON['data']) {
      chapterListRaw.add({
        "id": chapter["versions"][0]['id'],
        "number": chapter['number'],
        "uploadDate": chapter["versions"][0]['created_at']
      });
    }
    setState(() {
      chapterList = chapterListRaw;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: chapterList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              "Capítulo " + chapterList[index]['number'],
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: PageViewerScreen(
                          chapterID: chapterList[index]['id'])));
            },
          );
        });
  }
}
