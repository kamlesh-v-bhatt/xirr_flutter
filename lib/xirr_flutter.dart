library xirr_flutter;

import 'src/exceptions.dart';
import 'src/investment.dart';
import 'src/newton_raphson.dart';
import 'src/xirr_details.dart';
import 'transaction.dart';

/// Calculates the irregular rate of return on a series of transactions.  The
/// irregular rate of return is the constant rate for which, if the transactions
/// had been applied to an investment with that rate, the same resulting returns
/// would be realized.
/// <p>
/// When creating the list of {@link Transaction} instances to feed Xirr_Flutter, be
/// sure to include one transaction representing the present value of the account
/// now, as if you had cashed out the investment.
/// <p>
/// Example usage:
/// <code>
///     List<Transaction> transactions = [];
///
///     transactions.add(Transaction.withStringDate(-1000, "2016-01-15"));
///     transactions.add(Transaction.withStringDate(-2500, "2016-02-08"));
///     transactions.add(Transaction.withStringDate(-1000, "2016-04-17"));
///     transactions.add(Transaction.withStringDate(5050, "2016-08-24"));
///
///     final double? result =
///     XirrFlutter.withTransactions(transactions).calculate();
///     expect(result?.toPrecision(11), 0.25042347105);
/// </code>

class XirrFlutter {
  static const double daysInYear = 365;
  late final NewtonRaphson newtonRaphson;
  late final List<Investment> investments = [];
  late final XirrDetails details = XirrDetails();
  double? guess;

  XirrFlutter.withTransactions(List<Transaction> transactions) {
    processTransactions(transactions);
  }

  XirrFlutter.withTransactionsAndGuess(
      List<Transaction> transactions, this.guess) {
    processTransactions(transactions);
  }

  void processTransactions(List<Transaction> transactions) {
    if (transactions.length < 2) {
      throw MissingData();
    }
    for (var transaction in transactions) {
      details.accumulate(transaction);
    }
    details.validate();

    for (var transaction in transactions) {
      investments.add(createInvestment(transaction));
    }
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Investment createInvestment(Transaction tx) {
    // Transform the transaction into an Investment instance
    // It is much easier to calculate the present value of an Investment
    final Investment result = Investment();
    result.amount = tx.amount;
    // Don't use YEARS.between() as it returns whole numbers
    result.years = daysBetween(tx.when, details.end!) / daysInYear;
    return result;
  }

  /// Calculates the present value of the investment if it had been subject to
  /// the given rate of return.
  /// @param rate the rate of return
  /// @return the present value of the investment if it had been subject to the
  ///         given rate of return
  double presentValue(final double rate) {
    return investments.fold(0,
        (previousValue, element) => element.presentValue(rate) + previousValue);
  }

  /// The derivative of the present value under the given rate.
  /// @param rate the rate of return
  /// @return derivative of the present value under the given rate
  double derivative(final double rate) {
    return investments.fold(0,
        (previousValue, element) => element.derivative(rate) + previousValue);
  }

  /// Calculates the irregular rate of return of the transactions for this
  /// instance of Xirr.
  /// @return the irregular rate of return of the transactions
  /// @throws Exception if the derivative is 0 while executing the Newton-Raphson method
  /// @throws Exception if the Newton-Raphson method fails to converge in the
  double? calculate() {
    final double years = daysBetween(details.start!, details.end!) / daysInYear;
    if (details.maxAmount == 0) {
      return -1; // Total loss
    }
    guess = guess ?? (details.total! / details.deposits!) / years;
    return NewtonRaphson.withFunctions(presentValue, derivative)
        .findRoot(guess!);
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
