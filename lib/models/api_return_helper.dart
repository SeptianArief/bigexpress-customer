part of 'models.dart';

class ApiReturnValue<T> {
  T data;
  RequestStatus status;

  ApiReturnValue({required this.data, required this.status});

  static Future<ApiReturnValue<dynamic>?> httpRequest(
      {required http.MultipartRequest request,
      List<int>? exceptionStatusCode,
      bool? auth}) async {
    return ApiReturnValue(data: null, status: RequestStatus.failedParsing);
  }
}

enum RequestStatus {
  successRequest,
  failedRequest,
  failedParsing,
  serverError,
  internetIssue
}
