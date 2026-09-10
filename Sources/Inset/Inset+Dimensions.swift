public import Vector

extension Inset where N == 1 {
    public init(
        lower: Scalar,
        upper: Scalar
    ) {
        self.init(lower: Vector(x: lower), upper: Vector(x: upper))
    }
}

extension Inset where N == 2 {
    public init(
        x: (lower: Scalar, upper: Scalar),
        y: (lower: Scalar, upper: Scalar)
    ) {
        self.init(lower: Vector(x: x.lower, y: y.lower), upper: Vector(x: x.upper, y: y.upper))
    }
}

extension Inset where N == 3 {
    public init(
        x: (lower: Scalar, upper: Scalar),
        y: (lower: Scalar, upper: Scalar),
        z: (lower: Scalar, upper: Scalar)
    ) {
        self.init(
            lower: Vector(x: x.lower, y: y.lower, z: z.lower),
            upper: Vector(x: x.upper, y: y.upper, z: z.upper)
        )
    }
}

extension Inset where N == 2 {
    public init(top: Scalar, leading: Scalar, bottom: Scalar, trailing: Scalar) {
        self.init(x: (lower: leading, upper: trailing), y: (lower: bottom, upper: top))
    }

    public init(horizontal: Scalar, vertical: Scalar) {
        self.init(symmetric: Vector(x: horizontal, y: vertical))
    }

    public var top: Scalar {
        get { upper[1] }
        set { upper[1] = newValue }
    }

    public var leading: Scalar {
        get { lower[0] }
        set { lower[0] = newValue }
    }

    public var bottom: Scalar {
        get { lower[1] }
        set { lower[1] = newValue }
    }

    public var trailing: Scalar {
        get { upper[0] }
        set { upper[0] = newValue }
    }
}

extension Inset where N == 2, Scalar: AdditiveArithmetic {
    public var horizontal: Scalar { total[0] }
    public var vertical: Scalar { total[1] }
}
