import 'dart:core';

import 'exceptions.dart';

class Calculation {
  double? guess;
  int iteration = 0; // persistent loop counter
  double? candidate;
  double? value;
  double? derivativeValue;
  late final double Function(double) func;
  late final double Function(double) derivative;
  late final double tolerance;
  late final int iterations;

  Calculation(this.func, this.derivative, this.iterations, this.tolerance);

  double? getGuess() {
    return guess;
  }

  void setGuess(double guess) {
    this.guess = guess;
  }

  int getIteration() {
    return iteration + 1;
  }

  double? getCandidate() {
    return candidate;
  }

  void setCandidate(double candidate) {
    this.candidate = candidate;
    if (!(candidate.isFinite)) {
      throw CandidateIsInfinite(this);
    }
  }

  double? getValue() {
    return value;
  }

  void setValue(double value) {
    this.value = value;
    if (!(value.isFinite)) {
      throw FunctionValueOverflow(this);
    }
  }

  double? getDerivativeValue() {
    return derivativeValue;
  }

  void setDerivativeValue(double derivativeValue) {
    this.derivativeValue = derivativeValue;
    if (!(derivativeValue.isFinite)) {
      throw DerivativeValueOverflow(this);
    } else if (derivativeValue == 0.0) {
      throw ZeroValuedDerivativeException(this);
    }
  }

  @override
  String toString() {
    return "{ guess=$guess, iteration=$iteration, candidate=$candidate, value=$value, derivative=$derivativeValue }";
  }

  double? solve(double guess, double target) {
    setGuess(guess);
    setCandidate(guess);
    for (iteration = 0; iteration < iterations; iteration++) {
      setValue(func.call(candidate!) - target);
      if ((value?.abs())! < tolerance) {
        return candidate;
      } else {
        setDerivativeValue(derivative.call(candidate!));
        setCandidate(candidate! - value! / derivativeValue!);
      }
    }
    throw NonConvergenceException(guess, iterations);
  }
}
