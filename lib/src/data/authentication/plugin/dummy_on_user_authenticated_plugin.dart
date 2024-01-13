

import 'package:dantex/src/data/authentication/entity/dante_user.dart';
import 'package:dantex/src/data/authentication/on_user_authenticated_plugin.dart';

// TODO Remove later
class DummyOnUserAuthenticatedPlugin extends OnUserAuthenticatedPlugin {
  @override
  void onUserAuthenticated(DanteUser user) {
    print('User ${user.email} authenticated');
  }

}