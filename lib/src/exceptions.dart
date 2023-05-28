import 'package:xirr_flutter/src/calculation.dart';

class OverflowException implements Exception {
  late final Calculation _state;

  OverflowException(this._state);

  double? getInitialGuess() {
    return _state.getGuess();
  }

  int getIteration() {
    return _state.getIteration();
  }

  double? getCandidate() {
    return _state.candidate;
  }

  double? getValue() {
    return _state.value;
  }

  double? getDerivedValue() {
    return _state.derivativeValue;
  }

  @override
  toString() {
    return "${super.toString()}: $_state";
  }
}

class NonConvergenceException implements Exception {
  final double _initialGuess;
  final int _iterations;

  NonConvergenceException(this._initialGuess, this._iterations);

  double getInitialGuess() {
    return _initialGuess;
  }

  int getIterations() {
    return -_iterations;
  }

  String errorMessage() {
    return "Newton-Raphson failed to converge within $_iterations iterations.";
  }
}

class MissingData implements Exception {
  String errorMessage() {
    return "Must have at least two transactions";
  }
}

class InvalidDataForSameDay implements Exception {
  String errorMessage() {
    return "Transactions must not all be on the same day.";
  }
}

class CandidateIsInfinite extends OverflowException {
  CandidateIsInfinite(super.state);

  String errorMessage() {
    return "Candidate is infinite";
  }
}

class FunctionValueOverflow extends OverflowException {
  FunctionValueOverflow(super.state);

  String errorMessage() {
    return "Function value overflow";
  }
}

class DerivativeValueOverflow extends OverflowException {
  DerivativeValueOverflow(super.state);

  String errorMessage() {
    return "Derivative value overflow";
  }
}

class AllNegativeAmounts implements Exception {
  String errorMessage() {
    return "Transactions must not be negative.";
  }
}

class AllNonNegativeAmounts implements Exception {
  String errorMessage() {
    return "Transactions must not all be non-negative.";
  }
}

class ZeroValuedDerivativeException extends OverflowException {
  ZeroValuedDerivativeException(super.state);

  String errorMessage() {
    return "Newton-Raphson failed due to zero-valued derivative.";
  }
}
