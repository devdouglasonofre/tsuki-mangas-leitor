import 'package:flutter/material.dart';
import 'package:tsuki/widget/commom/chapter_list_widget.dart';

import '../../models/manga.dart';

class MangaDetailsScreen extends StatelessWidget {
  final Manga manga;

  const MangaDetailsScreen({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text(
          manga.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(children: [
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://tsukimangas.com/imgs/${manga.cover}"),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                  )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          width: 100,
                          height: 160,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://tsukimangas.com/imgs/${manga.poster}"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ), //BorderRa
                          )),
                      Container(
                        margin: EdgeInsets.all(24),
                        child: Text(
                          manga.title,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Escrito por:"),
                      ),
                      Container(
                        child: Text(manga.author),
                      ),
                      Container(
                        child: Text("Arte por:"),
                      ),
                      Container(child: Text(manga.artist)),
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(18),
                  child: Text(
                    manga.synopsis,
                    textAlign: TextAlign.justify,
                  )),
              SizedBox(height: 500, child: ChapterListWidget(mangaID: manga.id))
            ],
          ),
        ),
      ),
    );
  }
}
