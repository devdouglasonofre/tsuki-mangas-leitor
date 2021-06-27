import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:page_transition/page_transition.dart';
import 'package:tsuki/cubit/chapter_cubit.dart';
import 'package:tsuki/widget/screens/page_viewer_screen.dart';

class ChapterListWidget extends StatefulWidget {
  final int mangaID;
  final int chaptersCount;

  const ChapterListWidget(
      {Key? key, required this.mangaID, required this.chaptersCount})
      : super(key: key);

  @override
  _ChapterListWidgetState createState() => _ChapterListWidgetState();
}

class _ChapterListWidgetState extends State<ChapterListWidget> {
  bool loading = false;
  ScrollController _scrollController = new ScrollController();
  bool isCresc = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChapterCubit()..loadChapters(widget.mangaID, [], true),
      child:
          BlocConsumer<ChapterCubit, ChapterState>(listener: (context, state) {
        if (state is ChapterListLoaded) {
          loading = false;
        }
      }, builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: EdgeInsets.all(12),
                    child: Text(
                      "Capítulos",
                      style: TextStyle(fontSize: 24),
                    )),
                Container(
                  margin: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Cresc."),
                      Switch(
                        value: isCresc,
                        onChanged: (newValue) {
                          setState(() {
                            isCresc = newValue;
                            context
                                .read<ChapterCubit>()
                                .loadChapters(widget.mangaID, [], isCresc);
                          });
                        },
                      ),
                      Text("Decresc.")
                    ],
                  ),
                ),
              ],
            ),
            state is ChapterListLoaded
                ? NotificationListener(
                    child: Container(
                      height: 500,
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0.0),
                        itemCount: state.chaptersList.length,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              "Capítulo " + state.chaptersList[index]['number'],
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      child: PageViewerScreen(
                                          chapterID: state.chaptersList[index]
                                              ['id'],
                                          chapterName: state.chaptersList[index]
                                              ['number'])));
                            },
                          );
                        },
                      ),
                    ),
                    onNotification: (notification) {
                      if (notification is ScrollNotification &&
                          notification.metrics.extentAfter < 200 &&
                          loading == false &&
                          state.chaptersList.length != widget.chaptersCount) {
                        loading = true;
                        context.read<ChapterCubit>().loadChapters(
                            widget.mangaID, state.chaptersList, isCresc);
                      }
                      return true;
                    },
                  )
                : Center(child: CircularProgressIndicator())
          ],
        );
      }),
    );
  }
}
