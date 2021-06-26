import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tsuki/widget/commom/manga_widget.dart';
import 'package:http/http.dart' as http;

import 'models/manga.dart';

void main() {
  runApp(TsukiReader());
}

class TsukiReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leitor Tsuki Mangás',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white)),
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
      //https://tsukimangas.com/api/v2/mangas?title=
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Manga> mangas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Tsuki Mangás",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[850],
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  String result = await http.read(Uri.parse(
                      "https://tsukimangas.com/api/v2/mangas?title="));
                  Map resultJSON = json.decode(result);
                  List<Manga> mangasList = [];
                  for (Map manga in resultJSON['data']) {
                    mangasList.add(Manga(
                        id: manga['id'],
                        title: manga['title'],
                        cover: manga['cover'],
                        poster: manga['poster'],
                        artist: manga['artist'],
                        author: manga['author'],
                        synopsis: manga['synopsis'],
                        chaptersCount: manga['chapters_count']));
                  }
                  setState(() {
                    mangas = mangasList;
                  });
                  print("Foi!");
                })
          ],
        ),
        body: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              mainAxisExtent: 200,
              crossAxisSpacing: 0,
            ),
            itemCount: mangas.length,
            itemBuilder: (context, index) {
              //return Text(index.toString());
              return MangaWidget(manga: mangas[index]);
            })
        //children: [for (Manga manga in mangas) MangaWidget(manga: manga)]),
        );
  }
}
