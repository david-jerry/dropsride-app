import 'package:connectivity_plus/connectivity_plus.dart';

Future<String> checkConnectivity() async {
  // Check network connectivity
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // ignore: use_build_context_synchronously
    return 'No network connection. Please try checking if you have an active data plan';
  }

  if (connectivityResult == ConnectivityResult.vpn) {
    // ignore: use_build_context_synchronously
    return 'Your account will be suspended if you use a vpn';
  }

  return '';
}
