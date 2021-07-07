import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:photo_view/photo_view.dart';
import 'package:tsuki/cubit/page_cubit.dart';
import 'package:tsuki/models/chapter.dart';

class PageViewerScreen extends StatefulWidget {
  final int chapterID;
  final String chapterNumber;
  final int mangaID;

  const PageViewerScreen(
      {Key? key,
      required this.chapterID,
      required this.chapterNumber,
      required this.mangaID})
      : super(key: key);

  @override
  _PageViewerScreenState createState() => _PageViewerScreenState();
}

class _PageViewerScreenState extends State<PageViewerScreen> {
  double _page = 0;
  bool _loading = true;
  List<String> _pageList = [];
  PreloadPageController _preloadPageController = PreloadPageController();
  final PageStorageBucket _bucket = PageStorageBucket();
  var _previousChapter;
  var _nextChapter;

  void changeChapter(Chapter newChapter) {
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: PageViewerScreen(
                chapterID: newChapter.chapterId,
                chapterNumber: newChapter.chapterNumber,
                mangaID: widget.mangaID)));
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocListener<PageCubit, PageState>(
        bloc: PageCubit()
          ..loadPages(widget.chapterID, widget.chapterNumber, widget.mangaID),
        listener: (context, state) {
          if (state is PageListLoaded) {
            setState(() {
              _loading = false;
              _pageList = state.pagesList;
              _previousChapter = state.previousChapter;
              _nextChapter = state.nextChapter;
            });
          }
        },
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.grey[850],
              title: Text("Capítulo ${widget.chapterNumber}",
                  style: TextStyle(color: Colors.white)),
              actions: [
                if (!_loading && _previousChapter.chapterId != widget.chapterID)
                  IconButton(onPressed: () {
                    changeChapter(_previousChapter);
                  }, icon: Icon(Icons.skip_previous)),
                if (!_loading && _nextChapter.chapterId != widget.chapterID)
                  IconButton(onPressed: () {
                    changeChapter(_nextChapter);
                  }, icon: Icon(Icons.skip_next))
              ],
            ),
            body: !(_loading)
                ? PageStorage(
                    bucket: _bucket,
                    child: PreloadPageView.builder(
                        preloadPagesCount: 3,
                        scrollDirection: Axis.horizontal,
                        controller: _preloadPageController,
                        reverse: true,
                        itemCount: _pageList.length,
                        onPageChanged: (pageNumber) {
                          setState(() {
                            _page = pageNumber.toDouble();
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                              height: height,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Center(
                                child: CachedNetworkImage(
                                  imageUrl: _pageList[index],
                                  imageBuilder: (context, imageProvider) {
                                    return PhotoView(
                                        imageProvider: imageProvider);
                                  },
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  height: height,
                                ),
                              ));
                        }),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            bottomNavigationBar: BottomAppBar(
                color: Colors.grey[850],
                child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Container(
                      height: 20,
                      child: Slider(
                          max: _pageList.length.toDouble(),
                          min: 0,
                          value: _page,
                          divisions:
                              _pageList.length == 0 ? 1 : _pageList.length,
                          onChanged: (value) {
                            setState(() {
                              _page = value;
                              _preloadPageController.animateToPage(
                                  value.toInt(),
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                            });
                          }),
                    )))));
  }
}
