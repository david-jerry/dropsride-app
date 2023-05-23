import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text("Legal Page"),
        actions: [
          InkWell(
              onTap: () async {
                AuthController.instance.signOutUser();
              },
              child: const Icon(Icons.logout_sharp))
        ],
      ),
    );
  }
}
