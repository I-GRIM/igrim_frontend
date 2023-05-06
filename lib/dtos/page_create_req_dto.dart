import 'dart:convert';

class PageCreateReqDto {
  String content;
  List<String> characterName;
  List<String> characterPrompt;
  String imgUrl;
  int pageNum;

  PageCreateReqDto(this.content, this.characterName, this.characterPrompt,
      this.imgUrl, this.pageNum);

  String toJson() => json.encode({
        "content": content,
        "characterName": characterName,
        "characterPrompt": characterPrompt,
        "imgUrl": imgUrl,
        "pageNum": pageNum,
      });

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
