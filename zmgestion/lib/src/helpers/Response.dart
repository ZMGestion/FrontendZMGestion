import 'package:zmgestion/src/helpers/Request.dart';

class Response<T>{
  final RequestStatus status;
  final T message;

  const Response({
    this.status,
    this.message
  });
}
