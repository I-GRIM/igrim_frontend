class LoginResDto {
  String grantType, accessToken, refreshToken;
  int accessTokenExpireIn, refreshTokenExpiresIn;

  LoginResDto.fromJson(Map<String, dynamic> json)
      : grantType = json['grantType'],
        accessToken = json['accessToken'],
        refreshToken = json['refreshToken'],
        accessTokenExpireIn = json['accessTokenExpiresIn'],
        refreshTokenExpiresIn = json['refreshTokenExpiresIn'];
}
