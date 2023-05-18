class MakeNewCharacterResDto {
  String imgUrl;


  MakeNewCharacterResDto.fromJson(Map<String, dynamic> json)
      : imgUrl = json['imgUrl'];
}
