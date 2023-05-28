import 'package:flutter_test/flutter_test.dart';
import 'package:xirr_flutter/src/exceptions.dart';
import 'package:xirr_flutter/xirr_flutter.dart';

void main() {
  test('One year no growth', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(1000, "2011-01-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result, 0);
  });

  test('One year growth', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(1100, "2011-01-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result, 0.10);
  });

  test('One year decline', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(900, "2011-01-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result, -0.10);
  });

  test('Compared to spreadsheet output', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-10-01"));
    transactions.add(Transaction.withStringDate(4300, "2011-01-01"));
    transactions.add(Transaction.withStringDate(-1000, "2010-07-01"));
    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(-1000, "2010-04-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result?.toPrecision(7), 0.1212676);
  });

  test('100 percent growth', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(3000, "2011-01-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result, 2.00);
  });

  test('Total loss in a year', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(0, "2011-01-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result, -1.00);
  });

  test('Total loss in 2 years', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(0, "2012-01-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result, -1.00);
  });

  test('Total loss in 1/2 year', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(0, "2010-07-01"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result, -1.00);
  });

  test('Calculation from Sample method 1', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2016-01-15"));
    transactions.add(Transaction.withStringDate(-2500, "2016-02-08"));
    transactions.add(Transaction.withStringDate(-1000, "2016-04-17"));
    transactions.add(Transaction.withStringDate(5050, "2016-08-24"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();
    expect(result?.toPrecision(11), 0.25042347105);
  });

  test('issue from node js version', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-10000, "2000-05-24"));
    transactions.add(Transaction.withStringDate(3027.25, "2000-06-05"));
    transactions.add(Transaction.withStringDate(630.68, "2001-04-09"));
    transactions.add(Transaction.withStringDate(2018.2, "2004-02-24"));
    transactions.add(Transaction.withStringDate(1513.62, "2005-03-18"));
    transactions.add(Transaction.withStringDate(1765.89, "2006-02-15"));
    transactions.add(Transaction.withStringDate(4036.33, "2007-01-10"));
    transactions.add(Transaction.withStringDate(4036.33, "2007-11-14"));
    transactions.add(Transaction.withStringDate(1513.62, "2008-12-17"));
    transactions.add(Transaction.withStringDate(1513.62, "2010-01-15"));
    transactions.add(Transaction.withStringDate(2018.16, "2011-01-14"));
    transactions.add(Transaction.withStringDate(1513.62, "2012-02-03"));
    transactions.add(Transaction.withStringDate(1009.08, "2013-01-18"));
    transactions.add(Transaction.withStringDate(1513.62, "2014-01-24"));
    transactions.add(Transaction.withStringDate(1513.62, "2015-01-30"));
    transactions.add(Transaction.withStringDate(1765.89, "2016-01-22"));
    transactions.add(Transaction.withStringDate(1765.89, "2017-01-20"));
    transactions.add(Transaction.withStringDate(22421.55, "2017-06-05"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();

    expect(result?.toPrecision(7), 0.2126861);
  });

  test('issue 5a', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-2610, "2001-06-22"));
    transactions.add(Transaction.withStringDate(-2589, "2001-07-03"));
    transactions.add(Transaction.withStringDate(-5110, "2001-07-05"));
    transactions.add(Transaction.withStringDate(-2550, "2001-07-06"));
    transactions.add(Transaction.withStringDate(-5086, "2001-07-09"));
    transactions.add(Transaction.withStringDate(-2561, "2001-07-10"));
    transactions.add(Transaction.withStringDate(-5040, "2001-07-12"));
    transactions.add(Transaction.withStringDate(-2552, "2001-07-13"));
    transactions.add(Transaction.withStringDate(-2530, "2001-07-16"));
    transactions.add(Transaction.withStringDate(29520, "2001-07-17"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();

    expect(result?.toPrecision(7), -0.7640294);
  });

  test('issue 5b', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-2610, "2001-06-22"));
    transactions.add(Transaction.withStringDate(-2589, "2001-07-03"));
    transactions.add(Transaction.withStringDate(-5110, "2001-07-05"));
    transactions.add(Transaction.withStringDate(-2550, "2001-07-06"));
    transactions.add(Transaction.withStringDate(-5086, "2001-07-09"));
    transactions.add(Transaction.withStringDate(-2561, "2001-07-10"));
    transactions.add(Transaction.withStringDate(-5040, "2001-07-12"));
    transactions.add(Transaction.withStringDate(-2552, "2001-07-13"));
    transactions.add(Transaction.withStringDate(-2530, "2001-07-16"));
    transactions.add(Transaction.withStringDate(-9840, "2001-07-17"));
    transactions.add(Transaction.withStringDate(38900, "2001-07-18"));

    final double? result =
        XirrFlutter.withTransactions(transactions).calculate();

    expect(result, -0.8353404468272648);
  });

  test('Transaction with guess parameter', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-2610, "2001-06-22"));
    transactions.add(Transaction.withStringDate(-2589, "2001-07-03"));
    transactions.add(Transaction.withStringDate(-5110, "2001-07-05"));
    transactions.add(Transaction.withStringDate(-2550, "2001-07-06"));
    transactions.add(Transaction.withStringDate(-5086, "2001-07-09"));
    transactions.add(Transaction.withStringDate(-2561, "2001-07-10"));
    transactions.add(Transaction.withStringDate(-5040, "2001-07-12"));
    transactions.add(Transaction.withStringDate(-2552, "2001-07-13"));
    transactions.add(Transaction.withStringDate(-2530, "2001-07-16"));
    transactions.add(Transaction.withStringDate(-9840, "2001-07-17"));
    transactions.add(Transaction.withStringDate(38900, "2001-07-18"));

    final double? result =
        XirrFlutter.withTransactionsAndGuess(transactions, -0.90).calculate();

    expect(result, -0.835340446830991);
  });

  test('issue 23 is impossible', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-2000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(2508.80, "2012-01-01"));

    double? result = XirrFlutter.withTransactions(transactions).calculate();

    expect(result?.toPrecision(7), 0.12);

    transactions.clear();
    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(-1120, "2011-01-01"));
    transactions.add(Transaction.withStringDate(2508.8, "2012-01-01"));

    result = XirrFlutter.withTransactions(transactions).calculate();

    expect(result?.toPrecision(7), 0.12);

    transactions.clear();
    transactions.add(Transaction.withStringDate(-2000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(2508.80, "2013-01-01"));

    result = XirrFlutter.withTransactions(transactions).calculate();

    expect(result?.toPrecision(7), 0.0784055);

    transactions.clear();
    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(-1120, "2011-01-01"));
    transactions.add(Transaction.withStringDate(2508.8, "2013-01-01"));

    result = XirrFlutter.withTransactions(transactions).calculate();

    expect(result?.toPrecision(8), 0.07017196);
  });

  test('Negative: No transactions exception', () {
    List<Transaction> transactions = [];

    expect(() => XirrFlutter.withTransactions(transactions),
        throwsA(isA<MissingData>()));
  });

  test('Negative: Single transaction only exception', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));

    expect(() => XirrFlutter.withTransactions(transactions),
        throwsA(isA<MissingData>()));
  });

  test('Negative: All transactions for same day exception', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01 09:00"));
    transactions.add(Transaction.withStringDate(-1000, "2010-01-01 12:00"));
    transactions.add(Transaction.withStringDate(2100, "2010-01-01 15:00"));

    expect(() => XirrFlutter.withTransactions(transactions).calculate(),
        throwsA(isA<InvalidDataForSameDay>()));
  });

  test('Negative: All transactions are negative exception', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(-1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(-1000, "2010-05-01"));
    transactions.add(Transaction.withStringDate(-2000, "2010-09-01"));

    expect(() => XirrFlutter.withTransactions(transactions),
        throwsA(isA<AllNegativeAmounts>()));
  });

  test('Negative: All transactions are with positive amount exception', () {
    List<Transaction> transactions = [];

    transactions.add(Transaction.withStringDate(1000, "2010-01-01"));
    transactions.add(Transaction.withStringDate(1000, "2010-05-01"));
    transactions.add(Transaction.withStringDate(0, "2010-09-01"));

    expect(() => XirrFlutter.withTransactions(transactions),
        throwsA(isA<AllNonNegativeAmounts>()));
  });
}
