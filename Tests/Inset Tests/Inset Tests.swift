import Inset
import Testing

@Suite
struct `Inset values and call sites` {
    @Test
    func `One dimensional insets preserve signed boundary amounts`() {
        let inset = Inset(lower: 2, upper: -3)
        #expect(inset.lower == Vector(x: 2))
        #expect(inset.upper == Vector(x: -3))
        #expect(inset.total == Vector(x: -1))
    }

    @Test
    func `Named axes construct two and three dimensional insets`() {
        let plane = Inset(x: (lower: 1, upper: 2), y: (lower: 3, upper: 4))
        #expect(plane.lower == Vector(x: 1, y: 3))
        #expect(plane.upper == Vector(x: 2, y: 4))
        let volume = Inset(x: (1, 2), y: (3, 4), z: (5, 6))
        #expect(volume.lower == Vector(x: 1, y: 3, z: 5))
        #expect(volume[2].lower == 5)
        #expect(volume[2].upper == 6)
    }

    @Test
    func `Uniform and symmetric constructors retain per axis meaning`() {
        let uniform = Inset<2, Int>(all: 5)
        #expect(uniform == Inset(x: (5, 5), y: (5, 5)))
        let symmetric = Inset(symmetric: Vector(x: -2, y: 8))
        #expect(symmetric == Inset(x: (-2, -2), y: (8, 8)))
    }

    @Test
    func `Higher dimensions use the reexported vector owner`() {
        let inset = Inset<4, Int>(
            lower: Vector<4, Int>([1, 2, 3, 4]),
            upper: Vector<4, Int>([5, 6, 7, 8])
        )
        #expect(inset.total == Vector<4, Int>([6, 8, 10, 12]))
    }

    @Test
    func `Zero dimensions never access a component`() {
        let inset = Inset<0, Int>(all: -1)
        #expect(inset == .zero)
        #expect(inset.total == Vector<0, Int>.zero)
        var calls = 0
        let mapped = inset.map { value in calls += 1; return String(value) }
        #expect(calls == 0)
        #expect(mapped == Inset<0, String>(all: "unused"))
    }

    @Test
    func `Reversal exchanges boundaries without negating amounts`() {
        let inset = Inset(x: (-1, 2), y: (3, -4))
        #expect(inset.reversed == Inset(x: (2, -1), y: (-4, 3)))
        #expect(inset.reversed.reversed == inset)
    }

    @Test
    func `Combination and subtraction reuse component arithmetic`() {
        let a = Inset(x: (1, 2), y: (3, 4))
        let b = Inset(x: (-5, 6), y: (7, -8))
        #expect(a + b == Inset(x: (-4, 8), y: (10, -4)))
        #expect((a + b) - b == a)
        #expect(a + .zero == a)
        #expect(a - a == .zero)
        #expect((a + b).total == a.total + b.total)
    }

    @Test
    func `Duration amounts do not require a numeric scalar`() {
        let inset = Inset(lower: Duration.seconds(2), upper: .seconds(-1))
        #expect(inset.total == Vector(x: .seconds(1)))
        #expect(inset - inset == .zero)
    }

    @Test
    func `Mapping visits lower axes before upper axes`() {
        var visited: [Int] = []
        let result = Inset(x: (1, 3), y: (2, 4)).map { value in
            visited.append(value)
            return String(value)
        }
        #expect(visited == [1, 2, 3, 4])
        #expect(result == Inset(x: ("1", "3"), y: ("2", "4")))
    }

    @Test
    func `Mapping stops at the first failure`() {
        enum Failure: Error { case rejected }
        var visited: [Int] = []
        #expect(throws: Failure.rejected) {
            try Inset(x: (1, 3), y: (2, 4)).map { value in
                visited.append(value)
                if value == 3 { throw Failure.rejected }
                return value
            }
        }
        #expect(visited == [1, 2, 3])
    }

    @Test
    func `Mutation and equality preserve the lower upper distinction`() {
        let original = Inset(lower: 1, upper: 2)
        var copy = original
        copy.lower[0] = 9
        #expect(original.lower[0] == 1)
        #expect(copy != original)
        #expect(Set([original, original, original.reversed]).count == 2)
        func requireSendable<T: Sendable>(_ value: T) {}
        requireSendable(copy)
    }
}
