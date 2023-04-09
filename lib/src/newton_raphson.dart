import 'dart:core';

import 'calculation.dart';

/// Simple implementation of the Newton-Raphson method for finding roots or
/// inverses of a function.
/// <p>
/// The function and its derivative must be supplied as instances of
/// Function and the answers are computed as doubles.
/// <p>
/// For examples of usage, see the source of the test class or the Xirr class.
/// <p>
/// The <code>iterations</code> parameter is used as an upper bound on the number
/// of iterations to run the method for.
/// <p>
/// The <code>tolerance</code> parameter is used to determine when the method
/// has been successful.  If the value of the function at the candidate input
/// is within the <code>tolerance</code> of the desired target value, the
/// method terminates.
class NewtonRaphson {
  /// Default tolerance.
  static const double defaultTolerance = 0.0000001;
  static const int defaultMaxIterations = 10000;
  late final double Function(double) func;
  late final double Function(double) derivative;
  late final double tolerance;
  late final int iterations;

  /// Construct an instance of the NewtonRaphson method
  /// @param func the function
  /// @param derivative the derivative of the function
  /// @param tolerance the tolerance
  /// @param iterations maximum number of iterations
  NewtonRaphson(this.func, this.derivative, this.tolerance, this.iterations);

  NewtonRaphson.withFunctions(this.func, this.derivative) {
    tolerance = defaultTolerance;
    iterations = defaultMaxIterations;
  }

  NewtonRaphson.withFunctionsAndTolerance(
      this.func, this.derivative, this.tolerance) {
    iterations = defaultMaxIterations;
  }

  /// Equivalent to <code>inverse(0, guess)</code>.
  /// <p>
  /// Find a root of the function starting at the given .  Equivalent to
  /// invoking <code>inverse(0, guess)</code>.  Finds the input value <i>x</i>
  /// such that |<i>f</i>(<i>x</i>)| &lt; <i>tolerance</i>.
  /// @param guess the value to start at
  /// @return an input to the function which yields zero within the given
  ///         tolerance
  /// @see #inverse(double, double)
  double? findRoot(final double guess) {
    return inverse(0, guess);
  }

  /// Find the input value to the function which yields the given
  /// <code>target</code>, starting at the <code>guess</code>.  More precisely,
  /// finds an input value <i>x</i>
  /// such that |<i>f</i>(<i>x</i>) - <code>target</code>| &lt; <i>tolerance</i>
  /// @param target the target value of the function
  /// @param guess value to start the algorithm with
  /// @return the inverse of the function at <code>target</code> within the
  /// given tolerance
  /// @throws ZeroValuedDerivativeException if the derivative is 0 while
  ///                                       executing the Newton-Raphson method
  /// @throws OverflowException when a value involved is infinite or NaN
  /// @throws NonconvergenceException if the method fails to converge in the
  ///                                 given number of iterations
  double? inverse(final double target, final double guess) {
    return Calculation(func, derivative, iterations, tolerance)
        .solve(guess, target);
  }
}
