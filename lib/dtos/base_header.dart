class BaseHeader {
  String contentType = 'application/json';
  //String accessToken = JwtService.getJwt();

  Map<String, String> toJson() => {
        'Content-Type': contentType,
      };
}
