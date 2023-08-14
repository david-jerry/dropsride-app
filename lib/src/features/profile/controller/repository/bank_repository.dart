import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropsride/src/features/auth/controller/auth_controller.dart';
import 'package:dropsride/src/features/profile/model/bank_model.dart';
import 'package:dropsride/src/utils/alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class BankRepository extends GetxController {
  static BankRepository get instance => Get.put(BankRepository());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user = FirebaseAuth.instance.currentUser;

  Future<List<dynamic>> fetchNigerianBanks() async {
    final response = await http.get(Uri.parse('https://api.paystack.co/bank'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final bankList = data['data'] as List<dynamic>;

      final banks = bankList.map((bank) => bank['name'].toString()).toList();
      return banks;
    } else {
      showErrorMessage(
          "Banks List",
          "Could not fetch nigerian banks. This can be due to network errors or a server error.",
          Icons.attach_money);
      return [];
    }
  }

  createUserBank(Bank bank) async {
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('bank')
          .doc(user!.uid)
          .set(bank.toMap())
          .whenComplete(() {
        showSuccessMessage(
            'Bank Account Created',
            'You have successfully added your bank account',
            FontAwesomeIcons.userInjured);
      }).catchError((error, stackTrace) {
        showErrorMessage('Bank Account Error', error.toString(),
            FontAwesomeIcons.userInjured);
      });
    }
  }

  Future<Bank?> userBankDetails() async {
    if (AuthController.find.userModel.value!.isDriver) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('bank')
            .where(FieldPath.documentId, isEqualTo: user!.uid)
            .get();

        final userBank = snapshot.docs.map((e) => Bank.fromSnapshot(e)).single;

        return userBank;
      } catch (e) {
        showInfoMessage("Bank Details", "Please add your bank details",
            FontAwesomeIcons.bank);
        return Bank();
      }
    }
    return Bank();
  }
}
