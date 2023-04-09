import 'package:flutter_test/flutter_test.dart';
import 'package:xirr_flutter/src/exceptions.dart';
import 'package:xirr_flutter/src/newton_raphson.dart';
import 'package:xirr_flutter/xirr_flutter.dart';

void main() {
  test('Square root', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return value * value;
    }, (final double value) {
      return 2 * value;
    });

    expect(newtonRaphson.inverse(4, 4)?.toPrecision(0), 2);
    expect(newtonRaphson.inverse(9, -9)?.toPrecision(0), -3);
    expect(newtonRaphson.inverse(625, 625)?.toPrecision(0), 25);
  });

  test('Cube root', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return value * value * value;
    }, (final double value) {
      return 3 * value * value;
    });

    expect(newtonRaphson.inverse(8, 8)?.toPrecision(0), 2);
    expect(newtonRaphson.inverse(-27, 27)?.toPrecision(0), -3);
    expect(newtonRaphson.inverse(15625, 15625)?.toPrecision(0), 25);
  });

  test('Quadratic root', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return (value - 4) * (value + 3);
    }, (final double value) {
      return 2 * value - 1;
    });

    expect(newtonRaphson.findRoot(10)?.toPrecision(0), 4);
    expect(newtonRaphson.findRoot(-10)?.toPrecision(0), -3);
    expect(newtonRaphson.findRoot(0.51)?.toPrecision(0), 4);
    expect(newtonRaphson.findRoot(0.49)?.toPrecision(0), -3);
  });

  test('Fail to coverage', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return (value - 4) * (value + 3);
    }, (final double value) {
      return 2 * value - 1;
    });

    expect(() => newtonRaphson.findRoot(0.5),
        throwsA(isA<ZeroValuedDerivativeException>()));
  });

  test('Fail to coverage with Verification', () {
    NewtonRaphson nr = NewtonRaphson.withFunctions((final double value) {
      return 2;
    }, (final double value) {
      return value > 0 ? 0.25 : 0;
    });

    try {
      nr.findRoot(3);
    } on ZeroValuedDerivativeException catch (e) {
      expect(e.getInitialGuess(), 3);
      expect(e.getIteration(), 2);
      expect(e.getCandidate(), -5);
      expect(e.getValue(), 2);
    }
  });

  test('Fail to coverage non convergence', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return 2 * value.sign;
    }, (final double value) {
      return 1;
    });

    expect(() => newtonRaphson.findRoot(1),
        throwsA(isA<NonConvergenceException>()));
  });

  test('Fail to coverage with bad candidate', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return double.maxFinite;
    }, (final double value) {
      return double.minPositive;
    });

    try {
      newtonRaphson.findRoot(3);
    } on CandidateIsInfinite catch (e) {
      expect(e.getInitialGuess(), 3);
      expect(e.getIteration(), 1);
      expect(double.negativeInfinity, e.getCandidate());
    }
  });

  test('Fail to coverage NaN function value', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return double.nan;
    }, (final double value) {
      return 1;
    });

    try {
      newtonRaphson.findRoot(3);
    } on FunctionValueOverflow catch (e) {
      expect(e.getInitialGuess(), 3);
      expect(e.getIteration(), 1);
      expect(e.getCandidate(), 3);
      expect(e.getValue()?.isNaN, true);
      expect(e.getDerivedValue(), isNull);
    }
  });

  test('Fail to coverage NaN derivative value', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctions((final double value) {
      return 2;
    }, (final double value) {
      return double.nan;
    });

    try {
      newtonRaphson.findRoot(3);
    } on DerivativeValueOverflow catch (e) {
      expect(e.getInitialGuess(), 3);
      expect(e.getIteration(), 1);
      expect(e.getCandidate(), 3);
      expect(e.getValue(), 2);
      expect(e.getDerivedValue()?.isNaN, true);
    }
  });

  test('Tolerance', () {
    NewtonRaphson newtonRaphson =
        NewtonRaphson.withFunctionsAndTolerance((final double value) {
      return value * value;
    }, (final double value) {
      return 2 * value;
    }, NewtonRaphson.defaultTolerance / 1000);

    expect(newtonRaphson.inverse(16, 16)?.toPrecision(0), 4);
    expect(newtonRaphson.inverse(225, 225)?.toPrecision(0), 15);
    expect(newtonRaphson.inverse(2, 2)?.toPrecision(10), 1.4142135624);
  });
}
