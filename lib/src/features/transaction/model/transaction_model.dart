// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionCategory {
  trip,
  wallet,
  card,
  subscription,
}

enum TransactionType {
  debit,
  deposit,
}

enum PaymentMethod {
  cash,
  card,
}

enum TransactionStatus {
  paid,
  failed,
  pending,
  cancelled,
}

class TransactionHistory {
  final String? uid;
  final String? payer;
  final String? image;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime addedOn;
  final double amount;
  final String referenceId;
  final TransactionStatus status;
  final PaymentMethod paymentMethod;

  TransactionHistory({
    TransactionStatus? status,
    PaymentMethod? paymentMethod,
    TransactionType? type,
    DateTime? addedOn,
    TransactionCategory? category,
    String? payer,
    this.image,
    this.uid,
    required this.amount,
    required this.referenceId,
  })  : status = status ?? TransactionStatus.pending,
        paymentMethod = paymentMethod ?? PaymentMethod.cash,
        type = type ?? TransactionType.debit,
        addedOn = addedOn ?? DateTime.now(),
        category = category ?? TransactionCategory.trip,
        payer = payer ?? 'Wallet Top Up';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.name,
      'addedOn': addedOn.millisecondsSinceEpoch,
      'category': category.name,
      'amount': amount,
      'referenceId': referenceId,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'payer': payer,
      'image': image,
    };
  }

  Map<String, dynamic> statusToMap() {
    return <String, dynamic>{
      'status': status.name,
    };
  }

  factory TransactionHistory.fromMap(Map<String, dynamic> map) {
    return TransactionHistory(
      uid: map['uid'] as String,
      payer: map['payer'],
      image: map['image'],
      type: map['type'] as TransactionType,
      category: map['category'] as TransactionCategory,
      amount: map['amount'] as double,
      referenceId: map['referenceId'] as String,
      status: map['status'] as TransactionStatus,
      paymentMethod: map['paymentMethod'] as PaymentMethod,
    );
  }

  factory TransactionHistory.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    TransactionType parseType(String type) {
      switch (type) {
        case "debit":
          return TransactionType.debit;
        case 'deposit':
          return TransactionType.deposit;
        default:
          return TransactionType.debit;
      }
    }

    PaymentMethod parsePaymentMethod(String type) {
      switch (type) {
        case "card":
          return PaymentMethod.card;
        default:
          return PaymentMethod.cash;
      }
    }

    TransactionCategory parseTransactionCategory(String type) {
      switch (type) {
        case "card":
          return TransactionCategory.card;
        case 'subscription':
          return TransactionCategory.subscription;
        case 'wallet':
          return TransactionCategory.wallet;
        default:
          return TransactionCategory.trip;
      }
    }

    TransactionStatus parseTransactionStatus(String type) {
      switch (type) {
        case "paid":
          return TransactionStatus.paid;
        case 'failed':
          return TransactionStatus.failed;
        case 'pending':
          return TransactionStatus.pending;
        default:
          return TransactionStatus.cancelled;
      }
    }

    return TransactionHistory(
      uid: document.id,
      type: parseType(data['type']),
      amount: data['amount'] as double,
      payer: data['payer'] ?? 'Wallet Top Up',
      image: data['image'],
      referenceId: data['referenceId'] as String,
      status: parseTransactionStatus(data['status']),
      paymentMethod: parsePaymentMethod(data['paymentMethod']),
      category: parseTransactionCategory(data['category']),
      addedOn: DateTime.fromMillisecondsSinceEpoch(data['addedOn']),
    );
  }
}
