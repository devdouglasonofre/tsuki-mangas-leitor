import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/cubit/manga_cubit.dart';
import 'package:tsuki/widget/commom/manga_widget.dart';

import 'models/manga.dart';
import 'widget/commom/search_bar.dart';

void main() {
  runApp(TsukiReader());
}

class TsukiReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MangaCubit>(
          create: (BuildContext context) => MangaCubit()..loadMangaList(),
        ),
      ],
      child: MaterialApp(
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
      ),
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
    return BlocBuilder<MangaCubit, MangaState>(
      builder: (context, state) {
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
                    onPressed: () {
                      context.read<MangaCubit>().loadMangaList();
                    }),
                SearchBarWidget()
              ],
            ),
            body: (state is MangaListLoaded)
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120,
                      mainAxisExtent: 200,
                      crossAxisSpacing: 0,
                    ),
                    itemCount: state.mangasList.length,
                    itemBuilder: (context, index) {
                      //return Text(index.toString());
                      return MangaWidget(manga: state.mangasList[index]);
                    })
                : Center(
                    child: CircularProgressIndicator(),
                  ));
      },
    );
  }
}
