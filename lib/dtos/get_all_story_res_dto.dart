class GetAllStoryResDto {
  String id, userId, title, status;

  GetAllStoryResDto(
      {required this.id,
      required this.userId,
      required this.status,
      required this.title});

  GetAllStoryResDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        title = json['title'],
        status = json['status'];

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
