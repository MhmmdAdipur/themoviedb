part of 'models.dart';

class ServiceResult extends Equatable {
  final bool isError;
  final String? message;
  final dynamic data;

  const ServiceResult({required this.isError, this.message, this.data});

  @override
  List<Object?> get props => [isError, message, data];
}
