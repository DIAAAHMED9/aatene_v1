import '../../general_index.dart';
import '../../api/core/api_helper.dart';

/// Blocks guest (not logged-in) users from opening protected routes.
///
/// Redirects to '/auth_required'.
class AuthGuardMiddleware extends GetMiddleware {
  AuthGuardMiddleware({this.featureName});

  final String? featureName;

  bool get _isGuest => ApiHelper.isGuestMode || !ApiHelper.hasAuthToken;

  @override
  RouteSettings? redirect(String? route) {
    if (_isGuest) {
      return RouteSettings(
        name: '/auth_required',
        arguments: <String, dynamic>{
          'featureName': featureName,
        },
      );
    }
    return null;
  }
}
