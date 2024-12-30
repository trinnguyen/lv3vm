//
//  Testings.swift
//  lc3vm
//
//  Created by Tri Nguyen on 12/30/24.
//

import Testing
import lc3vm

@Test func printHelloWorld() {
    
    /**
     .ORIG x3000 ; Program begins at x3000.
     LEA R0, prompt1
     PUTS
     HALT ; The program is done, all objectives met.
     prompt1    .STRINGZ "Hello World!"    ; String variable.
     .END
     */
    
    let input: [UInt16] = [
        0b1110000000000010,
        0b1111000000100010,
        0b1111000000100101,
        0b0000000001001000,
        0b0000000001100101,
        0b0000000001101100,
        0b0000000001101100,
        0b0000000001101111,
        0b0000000000100000,
        0b0000000001010111,
        0b0000000001101111,
        0b0000000001110010,
        0b0000000001101100,
        0b0000000001100100,
        0b0000000000100001,
        0b0000000000000000
    ]
    let (_, status, output) = runTest(input)
    #expect(status == 0)
    #expect(output.buf == ["Hello World!", "Program halts."])
}

// MARK: - starting test
func runTest(_ input: [UInt16]) -> (mc: Lc3Machine, status: Int32, output: MemOutput) {
    let output = MemOutput()
    let machine = Lc3Machine()
    let status = machine.start(0, input, output)
    return (machine, status, output)
}

