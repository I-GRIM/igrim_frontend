import 'package:igrim/exceptions/error_code.dart';

class BaseException implements Exception {
  String msg;
  ErrorCode code;
  BaseException(this.code, this.msg);
}
