class Chapter {
  int chapterId;
  String chapterNumber;

  Chapter({required this.chapterId, required this.chapterNumber});

  @override
  String toString() {
    return 'Chapter(chapterId: $chapterId, chapterNumber: $chapterNumber)';
  }

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        chapterId: json['chapterID'] as int,
        chapterNumber: json['chapterNumber'] as String,
      );

  Map<String, dynamic> toJson() => {
        'chapterID': chapterId,
        'chapterNumber': chapterNumber,
      };
}
