import 'package:dropsride/src/features/profile/controller/repository/bank_repository.dart';
import 'package:dropsride/src/features/profile/model/bank_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankController extends GetxController {
  static BankController get instance => Get.put(BankController());

  RxString bankName = "".obs;
  RxString bankAccountName = "".obs;
  RxBool submitting = false.obs;
  RxString bankAccountNumber = ''.obs;

  List<dynamic> bankList = [];

  Future<void> fetchBanks() async {
    bankList = await BankRepository.instance.fetchNigerianBanks();
  }

  Future<void> fetchBankAccount() async {
    final userData = await BankRepository.instance.userBankDetails();

    if (userData == null) {
      return;
    }

    bankName.value = userData.name;
    bankAccountName.value = userData.accountName;
    bankAccountNumber.value = userData.accountNumber;
  }

  Future<void> submitBank(GlobalKey<FormState> formKey) async {
    submitting.value = true;

    final bank = Bank(
      accountName: bankAccountName.value,
      accountNumber: bankAccountNumber.value,
      name: bankName.value,
    );

    if (!formKey.currentState!.validate()) {
      showWarningMessage(
          'Authentication Warning',
          "You must validate all necessary fields before submitting!",
          Icons.text_fields_sharp);

      submitting.value = false;
      return;
    }

    formKey.currentState!.save();
    formKey.currentState?.reset();

    BankRepository.instance.createUserBank(bank);
    showSuccessMessage(
        'Bank Account', "Added your bank details successfully", Icons.money);
    submitting.value = false;
  }
}
