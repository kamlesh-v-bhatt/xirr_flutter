import 'dart:math';

import '../transaction.dart';
import 'exceptions.dart';

/// Converts a stream of {@link Transaction} instances into the data needed for
/// the {@link Xirr} algorithm.
class XirrDetails {
  DateTime? start;
  DateTime? end;
  double minAmount = double.infinity;
  double maxAmount = double.negativeInfinity;
  double? total;
  double? deposits;

  void accumulate(final Transaction tx) {
    start =
        start != null ? (start!.isBefore(tx.when) ? start : tx.when) : tx.when;
    end = end != null ? (end!.isAfter(tx.when) ? end : tx.when) : tx.when;
    minAmount = min(minAmount, tx.amount);
    maxAmount = max(maxAmount, tx.amount);
    total = total == null ? tx.amount : total! + tx.amount;
    if (tx.amount < 0) {
      deposits = deposits == null ? tx.amount : deposits! - tx.amount;
    }
  }

  void validate() {
    if (start == null) {
      throw Exception("No transactions to analyze");
    }

    if (start == end) {
      throw InvalidDataForSameDay();
    }
    if (minAmount >= 0) {
      throw AllNonNegativeAmounts();
    }
    if (maxAmount < 0) {
      throw AllNegativeAmounts();
    }
  }
}
