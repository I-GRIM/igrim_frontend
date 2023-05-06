class MakeNewCharacterResDto {
  String imgUrl;

  MakeNewCharacterResDto(String imgUrl) : imgUrl = imgUrl;

  MakeNewCharacterResDto.fromJson(Map<String, dynamic> json)
      : imgUrl = json['imgUrl'];
}
