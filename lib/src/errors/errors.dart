import 'package:equatable/equatable.dart';

/// The searching error.
class SearchError extends Equatable implements Exception {
  /// The error message.
  final String message;

  /// Constructor.
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
