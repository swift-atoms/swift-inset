import Inset
import Testing

@Suite struct `Inset named edges` {
    @Test func `edge names construct the same canonical axis amounts`() {
        let named = Inset(top: 1, leading: 2, bottom: 3, trailing: 4)
        #expect(named == Inset(x: (2, 4), y: (3, 1)))
        #expect(named.horizontal == 6 && named.vertical == 4)
        #expect(Inset(horizontal: -2, vertical: 3) == Inset(top: 3, leading: -2, bottom: 3, trailing: -2))
    }

    @Test func `edge mutation updates its boundary and preserves snapshots`() {
        let original = Inset(top: -1, leading: 2, bottom: 3, trailing: -4)
        var changed = original
        changed.top = 10
        changed.leading = 20
        changed.bottom = 30
        changed.trailing = 40
        #expect(changed.lower == Vector(x: 20, y: 30))
        #expect(changed.upper == Vector(x: 40, y: 10))
        #expect(original.top == -1 && original.trailing == -4)
        #expect(-original == Inset(top: 1, leading: -2, bottom: -3, trailing: 4))
    }

    @Test func `names accept nonnumeric amounts and mapping keeps canonical order`() {
        let value = Inset(top: "top", leading: "leading", bottom: "bottom", trailing: "trailing")
        var visited: [String] = []
        let mapped = value.map { item in visited.append(item); return item.count }
        #expect(visited == ["leading", "bottom", "trailing", "top"])
        #expect(mapped.top == 3 && mapped.bottom == 6)
    }
}
