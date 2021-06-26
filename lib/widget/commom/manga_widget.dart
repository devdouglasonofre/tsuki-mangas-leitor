import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tsuki/widget/screens/manga_details_screen.dart';

import '../../models/manga.dart';

class MangaWidget extends StatelessWidget {
  final Manga manga;

  const MangaWidget({Key? key, required this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Container(
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
            Text(
              manga.title,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: MangaDetailsScreen(manga: manga)));
      },
    );
  }
}
