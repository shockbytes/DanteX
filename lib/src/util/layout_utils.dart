import 'package:flutter/material.dart';

/// Helper function when we are only interested in desktop devices
bool isDesktop(BoxConstraints constraints) {
  return getDeviceFormFactor(constraints) == DeviceFormFactor.desktop;
}

DeviceFormFactor getDeviceFormFactor(BoxConstraints constraints) {
  return switch (constraints.maxWidth) {
    < 768 => DeviceFormFactor.phone,
    < 1200 => DeviceFormFactor.tablet,
    double() => DeviceFormFactor.desktop,
  };
}

enum DeviceFormFactor {
  desktop,
  tablet,
  phone,
}
