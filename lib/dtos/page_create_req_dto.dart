import 'dart:convert';

class PageCreateReqDto {
  String content;
  List<String> characterName;
  List<String> characterPrompt;
  String imgUrl;
  int pageNum, x, y;

  PageCreateReqDto(
      {required this.content,
      required this.characterName,
      required this.characterPrompt,
      required this.imgUrl,
      required this.pageNum,
      required this.x,
      required this.y});

  String toJson() => json.encode({
        "content": content,
        "characterName": characterName,
        "characterPrompt": characterPrompt,
        "imgUrl": imgUrl,
        "pageNum": pageNum,
        "x": x,
        "y": y
      });

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
