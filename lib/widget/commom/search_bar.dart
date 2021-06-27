import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/cubit/manga_cubit.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      context.read<MangaCubit>().loadMangaListByName(_textController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimSearchBar(
      helpText: "Buscar Mangá",
      width: 200,
      color: Colors.grey[850],
      style: TextStyle(color: Colors.white),
      textController: _textController,
      onSuffixTap: () {
        setState(() {
          _textController.clear();
        });
      },
    );
  }
}
