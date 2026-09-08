@_exported public import Vector

/// Per-axis amounts measured inward from the lower and upper boundaries.
///
/// For an increasing coordinate axis, applying an inset means adding `lower`
/// to the lower bound and subtracting `upper` from the upper bound. Negative
/// amounts expand rather than contract. Application and handling crossed bounds
/// belong to the bounded domain, not this value. No writing direction is implied.
public struct Inset<let N: Int, Scalar> {
    public var lower: Vector<N, Scalar>
    public var upper: Vector<N, Scalar>

    public init(
        lower: Vector<N, Scalar>,
        upper: Vector<N, Scalar>
    ) {
        self.lower = lower
        self.upper = upper
    }

    /// Use the same amount at both ends of every axis.
    public init(all amount: Scalar) {
        self.init(lower: Vector(repeating: amount), upper: Vector(repeating: amount))
    }

    /// Use independently chosen amounts per axis, equally at both ends.
    public init(symmetric amounts: Vector<N, Scalar>) {
        self.init(lower: amounts, upper: amounts)
    }

    public subscript(axis: Int) -> (lower: Scalar, upper: Scalar) {
        (lower[axis], upper[axis])
    }

    /// Exchange the two boundaries without changing the inward sign convention.
    public var reversed: Self { Self(lower: upper, upper: lower) }

    /// Transform lower amounts in axis order, followed by upper amounts.
    public func map<Result>(_ transform: (Scalar) throws -> Result) rethrows -> Inset<N, Result> {
        try Inset<N, Result>(lower: lower.map(transform), upper: upper.map(transform))
    }
}

extension Inset: Equatable where Scalar: Equatable {}
extension Inset: Hashable where Scalar: Hashable {}
extension Inset: Sendable where Scalar: Sendable {}

extension Inset: AdditiveArithmetic where Scalar: AdditiveArithmetic {
    public static var zero: Self { Self(all: .zero) }

    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lower: lhs.lower + rhs.lower, upper: lhs.upper + rhs.upper)
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lower: lhs.lower - rhs.lower, upper: lhs.upper - rhs.upper)
    }

    /// Total inward amount per axis; this can be negative and is not a Size.
    public var total: Vector<N, Scalar> { lower + upper }
}

#if !hasFeature(Embedded)
extension Inset: Encodable where Scalar: Encodable {}
extension Inset: Decodable where Scalar: Decodable {}
#endif
