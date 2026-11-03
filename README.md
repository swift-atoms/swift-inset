# swift-inset

Use this package to store an amount at each boundary of each axis of an N-dimensional region, such as padding, margins, safe areas or tolerances. It holds only the amounts and never applies them to a region. Start from `Inset<N, Scalar>`. Its two boundaries are `Vector<N, Scalar>` values from swift-vector, which this package re-exports. Use swift-geometry instead when you want to shrink or grow a box by an inset. It names the two-dimensional case Geometry.Insets and applies it there.

## Laws

- Amounts are signed and unconstrained. The package does not say whether a positive amount points into or out of the region; that is up to the consumer. `Scalar` only needs `AdditiveArithmetic` for arithmetic, so non-numeric amounts such as `Duration` work.
- `reversed` swaps the lower and upper boundaries without negating anything, and reversing twice gives back the original. Prefix `-` negates every amount and leaves the boundaries where they are.
- `+`, `-` and `zero` work component by component on both boundaries, so `(a + b) - b == a` and `a - a == .zero`. `total` is `lower + upper` for each axis and is additive: `(a + b).total == a.total + b.total`.
- `map` visits every lower component in axis order, then every upper component in axis order. It stops at the first error it throws. When `N` is 0 it never calls the transform.
- Named edges assume x runs leading to trailing and y runs bottom to top. So `leading` is lower x, `trailing` is upper x, `bottom` is lower y and `top` is upper y. `horizontal` is `leading + trailing` and `vertical` is `bottom + top`.
- Coding uses the keys `lower` and `upper`, each holding that boundary's components as an array. Decoding fails unless both keys are present and each array has exactly `N` components. No other check is made, so negative amounts round-trip. Encoding only needs `Scalar: Encodable` and decoding only needs `Scalar: Decodable`. Neither is available under Embedded Swift.
