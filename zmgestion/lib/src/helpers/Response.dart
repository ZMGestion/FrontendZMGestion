import 'package:zmgestion/src/helpers/Request.dart';
import 'package:zmgestion/src/models/Paginaciones.dart';

class Response<T>{
  final RequestStatus status;
  final T message;
  final Paginaciones pageInfo;

  const Response({
    this.status,
    this.message,
    this.pageInfo
  });
}
