class StoryCreateResDto {
  String storyId;
  String userId;
  String title;
  String status;

  StoryCreateResDto.fromJson(Map<String, dynamic> json)
      : storyId = json['id'],
        userId = json['user_id'],
        title = json['title'],
        status = json['status'];
}
