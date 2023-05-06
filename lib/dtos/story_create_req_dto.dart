import 'dart:convert';

class StoryCreateReqDto {
  String title;

  StoryCreateReqDto(this.title);

  String toJson() => json.encode({
        'title': title,
      });

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
