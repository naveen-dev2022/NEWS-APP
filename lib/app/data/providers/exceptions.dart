import 'package:dio/dio.dart';

class Exceptions {
  static String DioExceptions(DioError err) {
    switch (err.type) {
      case DioErrorType.cancel:
        return 'Request to the server was cancelled';

      case DioErrorType.connectTimeout:
        return 'Connection request timeout';

      case DioErrorType.receiveTimeout:
        return 'Receive timeout in connection with API server';

      case DioErrorType.sendTimeout:
        return 'Send timeout in connection with API server';

      case DioErrorType.response:
        return handleResponse(err);

      default:
        return 'Something went wrong';
    }
  }

  static String handleResponse(DioError err) {
    switch (err.response!.statusCode!) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized request';
      case 403:
        return 'Forbidden request';
      case 404:
        return 'Page not found';
      case 405:
        return 'Methode not allowed';
      case 409:
        return 'Error due to a conflict';
      case 408:
        return 'Connection request timeout';
      case 414:
        return 'URI too long';
      case 415:
        return 'Unsupported media type';
      case 429:
        return 'Too many request sent';
      case 500:
        return 'Internal server error';
      case 501:
        return 'Not implemented';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      case 504:
        return 'Gateway timeout';
      default:
        return 'Oops something went wrong';
    }
  }
}
