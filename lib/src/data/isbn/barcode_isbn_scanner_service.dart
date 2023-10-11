import 'package:dantex/src/data/isbn/isbn_scanner_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BarcodeIsbnScannerService implements IsbnScannerService {
  @override
  Future<String> scanIsbn(BuildContext context) {
    return FlutterBarcodeScanner.scanBarcode(
      '#00000000', // Transparent line
      AppLocalizations.of(context)!.cancel,
      false,
      ScanMode.BARCODE,
    );
  }
}
