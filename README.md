# Inset

An N-dimensional pair of lower/upper inward amounts, with dimensional storage
owned by Vector. Importing Inset also exposes Vector.

```swift
import Inset

let interval = Inset(lower: 2, upper: -1)
let plane = Inset(x: (lower: 1, upper: 2), y: (lower: 3, upper: 4))
let volume = Inset(x: (1, 2), y: (3, 4), z: (5, 6))
let uniform = Inset<3, Int>(all: 8)
let symmetric = Inset(symmetric: Vector(x: 4, y: 8))
```

When passing vectors as boundary amounts, specify the resulting inset type, for
example `Inset<4, Int>(lower: lowerVector, upper: upperVector)`. Without that
context, a vector could also be the scalar of a one-dimensional inset.

## Contract

For an increasing axis with bounds `[a, b]`, an inset describes the candidate
bounds `[a + lower, b - upper]`. Positive amounts contract; negative amounts
expand. An inset is not a translation: positive amounts at opposite ends move
in opposite coordinate directions. Nor is it a Size: amounts and their total
may be negative. The scalar retains its own validity and arithmetic rules;
Inset does not promise finiteness, overflow-free arithmetic, or a valid result
when applied to bounds. Those checks belong to the applying domain.

`lower` and `upper` are coordinate-relative, not top/bottom, leading/trailing,
or screen-relative. Layout and frame interpretation belong to higher layers.
No universal coordinate frame or unit is inferred by this untagged value.

Addition/subtraction combine corresponding amounts using Scalar arithmetic.
Reversal swaps the boundary amounts, without negation. Mapping visits each
lower component followed by each upper component in axis order, stopping on
failure. Equality/hashing compare the representation, not its effect on a
particular region. Zero dimensions are permitted, as in Vector.

Conditional coding uses an object with `lower` and `upper` arrays. Vector owns
exact dimension validation; Encodable and Decodable are independent.

Production depends only on Vector and Swift. Foundation is used solely by the
coding tests. Local development resolves the URL dependency through
`atoms.xcworkspace`; no path dependency is required.
