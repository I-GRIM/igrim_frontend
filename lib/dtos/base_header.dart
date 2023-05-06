import 'package:igrim/services/jwt_service.dart';

class BaseHeader {
  String contentType = 'application/json';

  Future<Map<String, String>> toJson() async => {
        'Content-Type': contentType,
        'Authorization': 'Bearer ${await JwtService.getJwt()}'
      };
}
