//
//  Defs.swift
//  lc3vm
//
//  Created by Tri Nguyen on 12/30/24.
//

// MARK: - OP
enum Op: UInt16 {
    case ADD = 0b0001
    case AND = 0b0101
    case BR = 0b0000
    case JMP_RET = 0b1100
    case JSR = 0b0100
    case LD = 0b0010
    case LDI = 0b1010
    case LDR = 0b0110
    case LEA = 0b1110
    case NOT = 0b1001
    case RTI = 0b1000
    case ST = 0b0011
    case STI = 0b1011
    case STR = 0b0111
    case TRAP = 0b1111
}

// MARK: - Trap vector table
enum TrapVector: UInt16 {
    case GETC = 0x20
    case OUT = 0x21
    case PUTS = 0x22
    case IN = 0x23
    case PUTSP = 0x24
    case HALT = 0x25
}

// MARK: - 8 general purpose registers, 1 PC register and code data memory
enum Reg: Int, CaseIterable {
    case r0 = 0
    case r1 = 1
    case r2 = 2
    case r3 = 3
    case r4 = 4
    case r5 = 5
    case r6 = 6
    case r7 = 7
    case rPc = 8
    case rIr = 9
    case rPsr = 10
    case rCc = 11
}

// MARK: - Output
public protocol OutputBuffer {
    func putsStr(_ msg: String)
}
