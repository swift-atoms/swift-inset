import Foundation
import Inset
import Testing

@Suite
struct `Inset coding` {
    @Test
    func `Coding round trips signed amounts without adding size constraints`() throws {
        let inset = Inset(x: (-1, 3), y: (2, -4))
        let data = try JSONEncoder().encode(inset)
        #expect(try JSONDecoder().decode(Inset<2, Int>.self, from: data) == inset)
        #expect(try JSONDecoder().decode([String: [Int]].self, from: data) == [
            "lower": [-1, 2], "upper": [3, -4],
        ])
    }

    @Test(arguments: [
        #"{"lower":[1],"upper":[2,3]}"#,
        #"{"lower":[1,2],"upper":[3]}"#,
        #"{"lower":[1,2,3],"upper":[4,5]}"#,
        #"{"lower":[1,2],"upper":[3,4,5]}"#,
        #"{"lower":[1,2]}"#,
        #"{"lower":[1,2],"upper":[3,"four"]}"#,
    ])
    func `Decoding delegates exact dimensionality to each vector`(_ json: String) {
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(Inset<2, Int>.self, from: Data(json.utf8))
        }
    }

    @Test
    func `Zero dimensional coding retains both empty boundaries`() throws {
        let data = Data(#"{"lower":[],"upper":[]}"#.utf8)
        #expect(try JSONDecoder().decode(Inset<0, Int>.self, from: data) == .zero)
        let encoded = try JSONEncoder().encode(Inset<0, Int>.zero)
        #expect(try JSONDecoder().decode([String: [Int]].self, from: encoded) == [
            "lower": [], "upper": [],
        ])
    }

    @Test
    func `Encoding and decoding do not require the opposite conformance`() throws {
        struct Output: Encodable { let value: Int }
        struct Input: Decodable { let value: Int }
        let data = try JSONEncoder().encode(Inset(lower: Output(value: 1), upper: Output(value: 2)))
        let decoded = try JSONDecoder().decode(Inset<1, Input>.self, from: data)
        #expect(decoded.lower[0].value == 1)
        #expect(decoded.upper[0].value == 2)
    }
}
