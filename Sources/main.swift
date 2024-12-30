//
//  main.swift
//  lcvm
//
//  Created by Tri Nguyen on 12/30/24.
//
import Foundation

let path = "lc3vm_lc3vm.bundle/Contents/Resources/Assets/hello.obj"
do {
    let (boot, instrs) = try loadCode(path)
    let status = Lc3Machine().start(boot, instrs, ConsoleOutput())
    exit(status)
} catch {
    print(error)
    exit(1)
}

// MARK: - Output
class ConsoleOutput: OutputBuffer {
    func putsStr(_ msg: String) {
        Swift.print(msg)
    }
}

/// Load code from local file, return boot addr and list of instructions
private func loadCode(_ path: String) throws -> (boot: UInt16, instrs: [Instr]) {
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    var instrIndex: Data.Index = 0
    var boot: UInt16 = 0
    var lines: [Instr] = []
    while(true) {
        let line = data.read16BitsLine(lineIndex: instrIndex)
        guard let line else {
            break
        }
        // first line specific the beginnign of mem, usually 0x30
        if instrIndex == 0 {
            boot = line
        } else {
            lines.append(line)
        }
        instrIndex += 1
    }

    // verbose
    print("----- OBJ BEGIN -----")
    print("count instructions: \(lines.count)")
    for (i, line) in lines.enumerated() {
        print("\(i): \(line.bin)")
    }
    print("----- OBJ END -----")
    return (boot, lines)
}
