import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class TDeviceFunctions {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  // get android build data
  static Future<String> getDeviceInfoData() async {
    const String verticalBar = '\u007C';

    try {
      final AndroidDeviceInfo deviceData = await _deviceInfoPlugin.androidInfo;

      String deviceInfo = '''
    $verticalBar------------------------------------------$verticalBar
    |                 DEVICE INFO                           
    $verticalBar------------------------------------------$verticalBar
    |  SDK version: ${deviceData.version.sdkInt}          
    |  Version release: ${deviceData.version.release}     
    |  Manufacturer: ${deviceData.manufacturer}           
    |  Model: ${deviceData.model}                         
    |  Is low ram device: ${deviceData.isLowRamDevice}    
    |  Is physical device: ${deviceData.isPhysicalDevice} 
    $verticalBar------------------------------------------$verticalBar
  ''';
      return deviceInfo;

      // """
      //       |-----------------------------------------------------|
      //       |                   DEVICE INFO                       |
      //       -------------------------------------------------------
      //       |  SDK version: ${deviceData.version.sdkInt}          |
      //       |  Version release: ${deviceData.version.release}     |
      //       |  Manufacturer: ${deviceData.manufacturer}           |
      //       |  Model: ${deviceData.model}                         |
      //       |  Is low ram device: ${deviceData.isLowRamDevice}    |
      //       |  Is physical device: ${deviceData.isPhysicalDevice} |
      //       -------------------------------------------------------
      //       """;

      // return {
      //   'version.securityPatch': deviceData.version.securityPatch,
      //   'version.sdkInt': deviceData.version.sdkInt,
      //   'version.release': deviceData.version.release,
      //   'version.previewSdkInt': deviceData.version.previewSdkInt,
      //   'version.incremental': deviceData.version.incremental,
      //   'version.codename': deviceData.version.codename,
      //   'version.baseOS': deviceData.version.baseOS,
      //   'board': deviceData.board,
      //   'bootloader': deviceData.bootloader,
      //   'brand': deviceData.brand,
      //   'device': deviceData.device,
      //   'display': deviceData.display,
      //   'fingerprint': deviceData.fingerprint,
      //   'hardware': deviceData.hardware,
      //   'host': deviceData.host,
      //   'id': deviceData.id,
      //   'manufacturer': deviceData.manufacturer,
      //   'model': deviceData.model,
      //   'product': deviceData.product,
      //   'supportedAbis': deviceData.supportedAbis,
      //   'tags': deviceData.tags,
      //   'type': deviceData.type,
      //   'isPhysicalDevice': deviceData.isPhysicalDevice,
      //   'systemFeatures': deviceData.systemFeatures,
      //   'isLowRamDevice': deviceData.isLowRamDevice,
      // };
    } on PlatformException {
      return "Error: Fuchsia platform isn't supported";
    }
  }
}
