import 'package:kasassy/data/providers/_base_provider.dart';
import 'package:kasassy/data/providers/device_provider.dart';

class DeviceRepository {
  DeviceRepository({
    BaseDeviceProvider? baseDeviceProvider,
  }) : _deviceProvider = baseDeviceProvider ?? DeviceProvider();

  final BaseDeviceProvider _deviceProvider;

  Future<String> getuserLocation() => _deviceProvider.getUserLocation();

  void dispose() {
    _deviceProvider.dispose();
  }
}
