import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer' as developer;

import 'package:igrim/dtos/login_res_dto.dart';

class JwtService {
  static Future<String?> getJwt() async {
    const storage = FlutterSecureStorage();
    developer.log('${storage.read(key: "accesToken")}', name: "JwtService");
    return storage.read(key: "accesToken");
  }

  //save jwt token
  static Future<bool> storeJwt(LoginResDto loginResDto) async {
    try {
      developer.log("Store Jwt");
      const storage = FlutterSecureStorage();
      storage.write(key: "grantType", value: loginResDto.grantType);
      storage.write(key: "accesToken", value: loginResDto.accessToken);
      storage.write(key: "refreshToken", value: loginResDto.refreshToken);
      storage.write(
          key: "accessTokenExpireIn",
          value: loginResDto.accessTokenExpireIn.toString());
      storage.write(
          key: "refreshTokenExpiresIn",
          value: loginResDto.refreshTokenExpiresIn.toString());
    } catch (e) {
      developer.log(
        "Unable to Store Jwt",
        name: "JwtService",
      );
      return false;
    }
    return true;
  }
}
