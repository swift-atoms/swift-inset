@_exported public import Vector

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

    public subscript(axis: Int) -> (lower: Scalar, upper: Scalar) {
        (lower[axis], upper[axis])
    }

    public var reversed: Self { Self(lower: upper, upper: lower) }

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

    public var total: Vector<N, Scalar> { lower + upper }
}

#if !hasFeature(Embedded)
extension Inset: Encodable where Scalar: Encodable {}
extension Inset: Decodable where Scalar: Decodable {}
#endif

extension Inset {

    public init(all amount: Scalar) {
        self.init(lower: Vector(repeating: amount), upper: Vector(repeating: amount))
    }

    public init(symmetric amounts: Vector<N, Scalar>) {
        self.init(lower: amounts, upper: amounts)
    }
}

extension Inset where Scalar: SignedNumeric {
    public static prefix func - (value: Self) -> Self {
        value.map { -$0 }
    }
}
