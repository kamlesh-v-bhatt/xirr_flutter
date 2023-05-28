<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A Flutter library to calculate Internal Rate Of Return(XIRR) for financial investments.

## Features

Calculates Internal Rate Of Return(XIRR) to know return on investment. It uses Newton-Raphson method
for calculating Internal Rate Of Return

## Getting started

Library will throw exceptions if inputs are not in line with expectations

* If all transactions are positive/negative only
* If all transactions are for same day
* If no transactions are passed

Please check test cases to know more details

## Usage

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

## Additional information

This library was created based on Java Xirr library available
at https://github.com/RayDeCampo/java-xirr
Hence terms of the library and license follows original creator