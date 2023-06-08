class PageCreateResDto {
  String storyId, imgUrl, content;
  int pageOrder;
  PageCreateResDto(
      {required this.storyId,
      required this.pageOrder,
      required this.imgUrl,
      required this.content});

  PageCreateResDto.fromJson(Map<String, dynamic> json)
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
