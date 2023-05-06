enum ErrorCode {
  NEED_SIGN_IN(4000),
  OPEN_AI_API_ERROR(5000);

  const ErrorCode(this.code);
  final int code;
}
