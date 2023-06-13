import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/auth/controller/repository/authentication_repository.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding * 2),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              hSizedBox14,
              const Icon(
                Icons.mail_outline_rounded,
                size: AppSizes.iconSize * 5,
              ),
              hSizedBox4,
              Text(
                'Email Verification',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              hSizedBox2,
              Text(
                'A verification Email has been sent to your mail box address: ${AuthenticationRepository.instance.firebaseUser.value!.email}.\n\n You do not need to close the app. Once you have verified your account, we shall redirect you automatically.\n\nIf you did not get this email, try resending it again by clicking the button below.',
                textAlign: TextAlign.center,
              ),
              hSizedBox4,
              TextButton(
                  onPressed: () async {
                    await AuthController.instance.resendVerificationEmail();
                  },
                  child: Text('Resend Email',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.w900,
                          ))),
              hSizedBox4,
              TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // await FirebaseAuth.instance.currentUser!.delete();
                    // Get.to(() => SignUpScreen());
                  },
                  child: Text('Delete Account',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.red,
                            fontWeight: FontWeight.w900,
                          )))
            ],
          ),
        ),
      ),
    );
  }
}
