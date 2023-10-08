

import 'package:flutter/cupertino.dart';

abstract class IsbnScannerService {

  Future<String> scanIsbn(BuildContext context);
}