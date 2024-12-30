//
//  Lc3Machine.swift
//  lc3vm
//
//  Created by Tri Nguyen on 12/30/24.
//

import Foundation

public class Lc3Machine {
    
    private(set) var reg: [UInt16] = .init(repeating: 0, count: Reg.allCases.count)
    private var mem: [UInt16] = .init(repeating: 0, count: 1 << 16) // 2^16
    
    public init(){}
    
    public func start(_ boot: UInt16 = 0, _ instrs: [UInt16], _ output: OutputBuffer) -> Int32 {
        guard !instrs.isEmpty else { return 1 }
        print("Starting...")
        pc = boot
        
        // loading into memory
        for (i, instr) in instrs.enumerated() {
            mem[Int(boot) + i] = instr
        }

        // Run loop
        while(true) {
            // load intrs
            guard let instr = readMem(pc) else {
                break
            }
            pc += 1

            // read first 4-bits
            guard let op = Op(rawValue: instr >> 12) else { fatalError("Not found op") }
            switch op {
            case .ADD: fatalError("not supported: \(op)")
            case .AND: fatalError("not supported: \(op)")
            case .BR: fatalError("not supported: \(op)")
            case .JMP_RET: fatalError("not supported: \(op)")
            case .JSR: fatalError("not supported: \(op)")
            case .LD: fatalError("not supported: \(op)")
            case .LDI: fatalError("not supported: \(op)")
            case .LDR: fatalError("not supported: \(op)")
            case .LEA: // 1110(4) DR(3) PCoffset9(9)
                let dr = (instr << 4) >> 13
                let offset = (instr << 7) >> 7
                // The LEA instruction does not read memory to obtain the information to load into DR.
                // The address itself is loaded into DR.
                reg[Int(dr)] = pc + offset
            case .NOT: fatalError("not supported: \(op)")
            case .RTI: fatalError("not supported: \(op)")
            case .ST: // 0011(4) SR(3) PCoffset9(9)
                // The contents of the register specified by SR are stored in the memory location
                // whose address is computed by sign-extending bits [8:0] to 16 bits and adding this value to the incremented PC.
                // ST R4, HERE ; mem[HERE] ← R4
                let sr = (instr << 4) >> 13
                let offset = (instr << 7) >> 7
                let addr = pc + offset
                mem[Int(addr)] = reg[Int(sr)]
            case .STI: fatalError("not supported: \(op)")
            case .STR: fatalError("not supported: \(op)")
            case .TRAP: // 1111(4) 0000(4) trapvect8(8)
                let trapvect = instr & 0b0000_0000_1111_1111
                print("OP_TRAP: trapvect: 0x\(String(trapvect, radix: 16))")
                // save pc to r7
                reg[7] = pc
                pc = trapvect

                // trap vector
                guard let vector = TrapVector(rawValue: trapvect) else { fatalError("Vector not found") }
                switch vector {
                case .GETC: fatalError("Trap Vector not supported: \(vector)")
                case .OUT: fatalError("Trap Vector not supported: \(vector)")
                case .PUTS:
                    // Write a string of ASCII characters to the console display. The characters are contained
                    // in consecutive memory locations, one character per memory location, starting with
                    // the address specified in R0. Writing terminates with the occurrence of x0000 in a
                    // memory location.
                    var addr = reg[0]
                    var chars: [UInt8] = []
                    while true {
                        guard let line = readMem(addr) else { fatalError("missing line")}
                        guard line != 0x00 else {
                            // string terminates
                            break
                        }
                        chars.append(.init(clamping: line))
                        addr += 1
                    }
                    // PUTS print to console
                    let str = String(decoding: chars, as: Unicode.UTF8.self)
                    output.putsStr(str)
                case .IN: fatalError("Trap Vector not supported: \(vector)")
                case .PUTSP: fatalError("Trap Vector not supported: \(vector)")
                case .HALT:
                    output.putsStr("Program halts.")
                    return 0 // OK
                }

                // restore pc from r7
                pc = reg[7]

            }
        }
        
        return 1
    }
    
    private(set) var pc: UInt16 {
        get { reg[Reg.rPc.rawValue] }
        set { reg[Reg.rPc.rawValue] = newValue }
    }

    private func readMem(_ off: UInt16) -> UInt16? {
        mem[safe: Int(off)]
    }

    private func dumpVm() {
        print("-------------- DUMP VM ----------")
        print("PC: \(pc.bin) => \t\t\t\(readMem(pc)?.bin ?? "")")
        reg.enumerated().forEach { (o, e) in
            print("R\(o): \(e.bin)")
        }
        print("---------------------------------")
    }
}
