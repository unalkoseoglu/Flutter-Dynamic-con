import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

class NewDynamicAppIcon {
  static const MethodChannel _channel = MethodChannel('new_dynamic_app_icon');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Indicate whether the current platform supports dynamic app icons
  static Future<bool> get supportsAlternateIcons async {
    final bool supportsAltIcons = await _channel.invokeMethod('mSupportsAlternateIcons');
    return supportsAltIcons;
  }

  /// Fetch the current iconName
  ///
  /// Return null if the current icon is the default icon
  static Future<String?> getAlternateIconName() async {
    final String? altIconName = await _channel.invokeMethod('mGetAlternateIconName');
    return altIconName;
  }

  /// Sets [iconName] as the current icon for the app
  ///
  /// [iOS]: Use [showAlert] at your own risk as it uses a private/undocumented API to
  /// not show the icon change alert. By default, it shows the alert
  /// Reference: https://stackoverflow.com/questions/43356570/alternate-icon-in-ios-10-3-avoid-notification-dialog-for-icon-change/49730130#49730130
  ///
  /// Throws a [PlatformException] with description if
  /// it can't find [iconName] or there's any other error
  static Future setAlternateIconName(String? iconName, {bool showAlert = true}) async {
    log('setAlternateIconName: $iconName');
    await _channel.invokeMethod(
      'mSetAlternateIconName',
      <String, dynamic>{
        'iconName': iconName,
      },
    );
  }

  /// Fetches the icon batch number
  ///
  /// The default value of this property is `0` (to show no batch)
  static Future<int> getApplicationIconBadgeNumber() async {
    final int batchIconNumber = await _channel.invokeMethod('mGetApplicationIconBadgeNumber');
    return batchIconNumber;
  }

  /// Sets [batchIconNumber] as the batch number for the current icon for the app
  ///
  /// Set to 0 (zero) to hide the badge number.
  ///
  /// Throws a [PlatformException] in case an error
  static Future setApplicationIconBadgeNumber(int batchIconNumber) async {
    await _channel.invokeMethod('mSetApplicationIconBadgeNumber', <String, Object>{'batchIconNumber': batchIconNumber});
  }

  // For Android

  static Future<void> setIcon({required String icon, required List<String> listAvailableIcon}) async {
    Map<String, dynamic> data = {'icon': icon, 'listAvailableIcon': listAvailableIcon};
    await _channel.invokeListMethod('setIcon', data);
  }
}
