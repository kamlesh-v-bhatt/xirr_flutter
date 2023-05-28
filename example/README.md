Deposit/Investment should be provided with negative amount and withdrawals should be provided with
positive amount.

```dart

List<Transaction> transactions = [];

transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
transactions.add(Transaction.withStringDate(1100, "2011-01-01"));

final double? result =
XirrFlutter.withTransactions(transactions).calculate();
expect(result, 0.10);

```