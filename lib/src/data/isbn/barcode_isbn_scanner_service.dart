import 'package:dantex/src/data/isbn/isbn_scanner_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeIsbnScannerService implements IsbnScannerService {
  @override
  Future<String> scanIsbn() {
    return FlutterBarcodeScanner.scanBarcode(
      '#00000000', // Transparent line
      'cancel'.tr(),
      false,
      ScanMode.BARCODE,
    );
  }
}
