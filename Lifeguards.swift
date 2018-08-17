#!/usr/bin/swift
import Foundation

enum ShiftType {
    case START, END
}

class Shift: Comparable {
    var time:Int
    var id:Int
    var shift_type:ShiftType
    
    init(_ id:Int, time:Int, type:ShiftType) {
        self.id = id
        self.time = time
        self.shift_type = type
    }
    
    static func == (lhs:Shift, rhs:Shift) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs:Shift, rhs:Shift) -> Bool {
        return lhs.time < rhs.time
    }
    
}

var N:Int = 0
var all_shifts:[Shift] = []
var maxEndTime = 0

let input_file_path:String = "Inputs/10.in"
let output_file_path:String = "Outputs/10.out"

let inputFile = URL(fileURLWithPath: input_file_path)
let output_file = URL(fileURLWithPath: output_file_path)

do {
    let s = try String(contentsOf: inputFile)
    let lines = s.components(separatedBy: .newlines)
    N = Int(lines[0])!
    for i in 1..<lines.count {
        if lines[i].isEmpty { break }
        let l = lines[i].split(separator: " ")
        let s = Int(l[0])!
        let e = Int(l[1])!
        all_shifts.append(Shift(i, time: s, type: .START))
        all_shifts.append(Shift(i, time: e, type: .END))
    }
} catch {
    print(error)
}

all_shifts.sort()

var active_shifts:[Int:Int] = [:]
var time_covered:Int = 0
var last_time:Int = 0
var time_spent_working_alone:[Int] = [Int](repeating: 0, count: N + 1)
var least_time_spent_working_alone = 999999
for shift in all_shifts {
    
    if active_shifts.count == 1 {
        time_spent_working_alone[active_shifts.first!.key] = shift.time - last_time
    }
    
    if !active_shifts.isEmpty {
        time_covered += shift.time - last_time
    }
    
    if shift.shift_type == .START {
        active_shifts[shift.id] = shift.time
    }
    
    if shift.shift_type == .END {
        active_shifts.removeValue(forKey: shift.id)
    }
    
    last_time = shift.time
}

for (index, alone_time) in time_spent_working_alone.enumerated() {
    if index == 0 { continue }
    least_time_spent_working_alone = min(least_time_spent_working_alone, alone_time)
}

var max_time_covered_after_firing_lifeguard = time_covered - least_time_spent_working_alone
let output_file_url = URL(fileURLWithPath: output_file_path)
try "\(max_time_covered_after_firing_lifeguard)".write(to: output_file_url, atomically: false, encoding: .utf8)