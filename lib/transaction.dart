import 'dart:core';

/// Represents a transaction for the purposes of computing the irregular rate
/// of return.
/// <p>
/// Note that negative amounts represent deposits into the investment (and so
/// withdrawals from your cash).  Positive amounts represent withdrawals from the
/// investment (deposits into cash).  Zero amounts are allowed in case your
/// investment is now worthless.
/// @see Xirr
class Transaction {
  late final double amount;
  late final DateTime when;

  /// Construct a Transaction instance with the given amount at the given day.
  /// @param amount the amount transferred
  /// @param when the day the transaction took place
  Transaction(this.amount, this.when);

  /// Construct a Transaction instance with the given amount at the given day.
  /// @param amount the amount transferred
  /// @param when the day the transaction took place
  Transaction.withStringDate(this.amount, String when) {
    DateTime temp = DateTime.parse(when);
    this.when = DateTime(temp.year, temp.month, temp.day);
  }
}
