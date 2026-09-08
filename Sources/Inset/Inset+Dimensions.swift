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
