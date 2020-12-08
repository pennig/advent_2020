import Foundation

var lines = readLines().map(LineOfCode.init)

enum Instruction: String {
    case jmp
    case acc
    case nop
}

struct LineOfCode {
    var instruction: Instruction
    let offset: Int
    
    init(instruction: Instruction, offset: Int) {
        self.instruction = instruction
        self.offset = offset
    }

    init(_ string: String) {
        let line = string.components(separatedBy: " ")
        instruction = Instruction(rawValue: line[0]) ?? .nop
        offset = Int(line[1]) ?? 0
    }
}

extension Array where Element == LineOfCode {
    func flipping(_ index: Self.Index) -> Self {
        var flipped = self
        let loc = flipped[index]
        
        if loc.instruction == .jmp {
            flipped[index] = LineOfCode(instruction: .nop,  offset: loc.offset)
        } else if flipped[index].instruction == .nop {
            flipped[index] = LineOfCode(instruction: .jmp,  offset: loc.offset)
        }
        
        return flipped
    }
}

class Program {
    struct Loop: Error {}
    
    let lines: [LineOfCode]
    
    var visited = Set<Int>()
    var pointer = 0
    var accumulator = 0
    
    init(_ lines: [LineOfCode]) {
        self.lines = lines
    }
    
    func execute() throws -> Int {
        repeat {
            if visited.contains(pointer) { throw Loop() }
            
            visited.insert(pointer)
            let line = lines[pointer]
            switch line.instruction {
            case .jmp:
                pointer += line.offset
            case .acc:
                accumulator += line.offset
                pointer += 1
            case .nop:
                pointer += 1
            }
        } while pointer < lines.endIndex
        
        return accumulator
    }
}

// part 1
let loop = Program(lines)
do { try loop.execute() }
catch { print(loop.accumulator) }

// part 2
for i in lines.indices {
    if lines[i].instruction == .acc { continue }
    let program = Program(lines.flipping(i))
    do {
        print(try program.execute())
        break
    } catch {
        continue
    }
}
