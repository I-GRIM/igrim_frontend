class GetStoryByIdResDto {
  String storyId, imgUrl;
  int pageOrder;
  String content;
  GetStoryByIdResDto({
    required this.storyId,
    required this.pageOrder,
    required this.imgUrl,
    required this.content,
  });

  GetStoryByIdResDto.fromJson(Map<dynamic, dynamic> json)
      : storyId = json['storyId'],
        pageOrder = json['pageOrder'],
        imgUrl = json['imgUrl'],
        content = json['content'];
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
