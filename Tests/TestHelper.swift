//
//  TestHelper.swift
//  lc3vm
//
//  Created by Tri Nguyen on 12/30/24.
//

import lc3vm

public class MemOutput: OutputBuffer {
    
    private(set) var buf: [String] = []
    
    public func putsStr(_ msg: String) {
        buf.append(msg)
    }
}
