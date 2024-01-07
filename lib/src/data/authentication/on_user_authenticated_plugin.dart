

import 'package:dantex/src/data/authentication/entity/dante_user.dart';

abstract class OnUserAuthenticatedPlugin {

  void onUserAuthenticated(DanteUser user);
}