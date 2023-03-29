class TaleModel {
  final String title, thumb, author;

  TaleModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        author = json['author'];
}
