import 'package:dropsride/src/constants/gaps.dart';
import 'package:dropsride/src/constants/size.dart';
import 'package:dropsride/src/features/auth/view/sign_up_and_login_screen.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:dropsride/src/utils/email_utility.dart';
import 'package:dropsride/src/utils/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeactivateController extends GetxController {
  static DeactivateController get instance => Get.put(DeactivateController());

  RxBool deactivating = false.obs;
  RxString password = ''.obs;
  RxInt checkBoxChoice = 0.obs;
  RxString reason = "".obs;

  final _firebase = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> submitDeactivation(
      GlobalKey<FormState> formKey, BuildContext context) async {
    deactivating.value = true;

    if (!formKey.currentState!.validate()) {
      showWarningMessage(
          'Validation Error',
          "You must validate all necessary fields before submitting!",
          Icons.text_fields_sharp);

      deactivating.value = false;
      return;
    }

    formKey.currentState!.save();
    formKey.currentState?.reset();

    try {
      await user!.delete();

      // ! show success message
      showSuccessMessage(
        'Account Deactivation',
        "You have successfully deactivated your account. Please be patient while we delete every record we have of you in our servers.",
        Icons.no_accounts_rounded,
      );

      try {
        await sendEmail(
          user!.email!,
          'Deactivation Request',
          'You have successfully deactivated your account. All records and information you had provided to our platform has been destroyed and shall not be used anywhere on our platform. \n\nWe are still sad to see you go and hope we can find a way to get you back with us.\n\nYours Truly,\nDropsride Team.',
          false,
        );
      } catch (e) {
        showErrorMessage(
            "Recipient Error", e.toString(), Icons.mail_outline_rounded);
        deactivating.value = false;
        return;
      }

      try {
        await sendEmail(
          'support@dropsride.com',
          "${user!.email} Deactivation Request",
          "${user!.email} has requested to deactivate their account with this reason:\n\n${reason.value}",
          true,
        );
      } catch (e) {
        showErrorMessage(
            "Recipient Error", e.toString(), Icons.mail_outline_rounded);
        deactivating.value = false;
        return;
      }

      await _firebase.signOut();
      Get.offAll(() => SignUpScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        await showReauthenticationBottomSheet(context).whenComplete(() async {
          await user!.delete();

          // ! show success message
          showSuccessMessage(
            'Account Deactivation',
            "You have successfully deactivated your account",
            Icons.no_accounts_rounded,
          );

          await _firebase.signOut();
          Get.offAll(() => SignUpScreen());
        });
      }
      return;
    } catch (e) {
      showErrorMessage(
        'Account Deactivation',
        e.toString(),
        Icons.no_accounts_rounded,
      );
      return;
    }
  }

  Future<void> reauthUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: password.value);
        print(credential);
        try {
          await user.reauthenticateWithCredential(credential);
          showSuccessMessage(
              "Authentication Successful",
              "Your account has been authenticated. Please proceed.",
              FontAwesomeIcons.user);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-mismatch') {
            showErrorMessage('Reauthentication Error', e.message.toString(),
                FontAwesomeIcons.user);
          } else if (e.code == 'invalid-credential') {
            showErrorMessage('Reauthentication Error', e.message.toString(),
                FontAwesomeIcons.user);
          } else if (e.code == 'invalid-password') {
            showErrorMessage('Reauthentication Error', e.message.toString(),
                FontAwesomeIcons.user);
          } else if (e.code == 'invalid-email') {
            showErrorMessage('Reauthentication Error', e.message.toString(),
                FontAwesomeIcons.user);
          } else if (e.code == 'invalid-verification-code') {
            showErrorMessage('Reauthentication Error', e.message.toString(),
                FontAwesomeIcons.user);
          } else if (e.code == 'invalid-verification-id') {
            showErrorMessage('Reauthentication Error', e.message.toString(),
                FontAwesomeIcons.user);
          } else if (e.code == 'user-not-found') {
            showErrorMessage('Reauthentication Error', e.message.toString(),
                FontAwesomeIcons.user);
          }

          return;
        } catch (e) {
          showInfoMessage(
              'Reauthentication Error', e.toString(), FontAwesomeIcons.user);
          return;
        }
      } catch (e) {
        showErrorMessage("Auth Failure", "Failed to reauthenticate the user",
            FontAwesomeIcons.user);
        return;
      }
    }
  }

  Future<void> showReauthenticationBottomSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSizes.padding * 2),
      )),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.padding * 1.4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Reauthentication Required",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              hSizedBox2,
              const Text(
                'We need your password to confirm this action. Please provide the accurate password used to login into this account.',
              ),
              hSizedBox4,
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.4,
                      color:
                          Theme.of(context).colorScheme.onSecondaryContainer),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onSecondary,
                  isDense: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.margin,
                    ),
                    borderSide: const BorderSide(
                        width: AppSizes.p2, color: AppColors.primaryColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppSizes.margin,
                    ),
                    borderSide: const BorderSide(
                        width: AppSizes.p2, color: AppColors.red),
                  ),
                ),
                obscureText: true,
                onChanged: (value) {
                  password.value = value;
                },
              ),
              hSizedBox2,
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () async {
                    await reauthUser();
                  },
                  child: Text(
                    'Confirm',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 16,
                        ),
                  ),
                ),
              ),
              hSizedBox4,
            ],
          ),
        );
      },
    ).then(
      (value) {
        deactivating.value = false;
        return;
      },
    );
  }
}
