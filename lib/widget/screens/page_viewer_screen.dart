import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:tsuki/cubit/page_cubit.dart';

class PageViewerScreen extends StatefulWidget {
  final int chapterID;
  final int nextChapterID;
  final int previousChapterID;
  final String chapterName;

  const PageViewerScreen(
      {Key? key,
      required this.chapterID,
      required this.chapterName,
      required this.nextChapterID,
      required this.previousChapterID})
      : super(key: key);

  @override
  _PageViewerScreenState createState() => _PageViewerScreenState();
}

class _PageViewerScreenState extends State<PageViewerScreen> {
  double _page = 0;
  PreloadPageController _preloadPageController = PreloadPageController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return BlocBuilder<PageCubit, PageState>(
      bloc: PageCubit()..loadPages(widget.chapterID),
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Colors.grey[850],
              title: Text("Capítulo ${widget.chapterName}",
                  style: TextStyle(color: Colors.white)),
            ),
            body: (state is PageListLoaded)
                ? PreloadPageView.builder(
                    preloadPagesCount: 3,
                    scrollDirection: Axis.horizontal,
                    controller: _preloadPageController,
                    reverse: true,
                    itemCount: state.pagesList.length,
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
                              imageUrl: state.pagesList[index],
                              imageBuilder: (context, imageProvider) {
                                return PhotoView(imageProvider: imageProvider);
                              },
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              height: height,
                            ),
                          ));
                    })
                : Center(child: CircularProgressIndicator()),
            bottomNavigationBar: (state is PageListLoaded)
                ? BottomAppBar(
                    color: Colors.grey[850],
                    child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Container(
                          height: 20,
                          child: Slider(
                              max: state.pagesList.length.toDouble(),
                              min: 0,
                              value: _page,
                              divisions: state.pagesList.length == 0
                                  ? 1
                                  : state.pagesList.length,
                              onChanged: (value) {
                                setState(() {
                                  _page = value;
                                  _preloadPageController.animateToPage(
                                      value.toInt(),
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                });
                              }),
                        )))
                : null);
      },
    );
  }
}
