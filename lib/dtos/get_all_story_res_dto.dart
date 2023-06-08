class GetAllStoryResDto {
  String id, userId, title, status, titleImgUrl;

  GetAllStoryResDto(
      {required this.id,
      required this.userId,
      required this.status,
      required this.title,
      required this.titleImgUrl});

  GetAllStoryResDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        title = json['title'],
        status = json['status'],
        titleImgUrl = json['title_img_url'];

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
