import 'package:equatable/equatable.dart';

class SearchError extends Equatable implements Exception {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
