//
//  Extensions.swift
//  lc3vm
//
//  Created by Tri Nguyen on 12/30/24.
//
import Foundation

typealias Instr = UInt16
extension UInt16 {

    init(first: UInt8, second: UInt8) {
        var base = UInt16(clamping: first) << 8
        base = base | UInt16(clamping: second)
        self = base
    }

    public var bin: String {
        self.verbose(pad: 16)
    }
}

extension Data {
    func read16BitsLine(lineIndex: Data.Index) -> Instr? {
        let i = lineIndex * 2
        if i % 2 == 0, i < self.count {
            return .init(first: self[i], second: i+1 < self.count ? self[i+1] : 0)
        }

        return nil
    }
}

extension BinaryInteger {
    func verbose(pad: Int) -> String {
        let m = String(self, radix: 2)
        let missing = pad - m.count
        if missing > 0 {
            return "\(String(String(repeating: "0", count: missing)))\(m)"
        }
        return m
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
