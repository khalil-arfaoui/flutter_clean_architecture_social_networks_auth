import '../const/failure_messages.dart';
import '../error/failures.dart';

class Utils {
  String mapFailureToMessage(Failure failure) {
    //! Instead of a regular 'if (failure is ServerFailure)...'
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message ?? SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
