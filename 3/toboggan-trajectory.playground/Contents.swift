import Cocoa

var str = "Hello, playground"


let filename = "test-input.txt"
let f = Bundle.main.url(forResource: "input", withExtension: "txt")
var map = try? String(contentsOf: f!)

var tree_map = [[Bool]]()
var row = 0

map?.enumerateLines { (line, _) in
    print(line)
    tree_map.append([Bool]())
    for (_, c) in line.enumerated() {
        tree_map[row].append(c == "#")
    }
    row += 1
}

let start_col = 0
let start_row = 0
var right: [Int] = [1, 3, 5, 7, 1]
var down: [Int] = [1, 1, 1, 1, 2]
var tree_count: [Int] = [0, 0, 0, 0, 0]

for i in 0..<right.count {
    
    var row_pos = start_row
    var col_pos = start_col
    tree_count[i] = 0
    while row_pos < tree_map.count {
        
        // print("\(col_pos) , \(row_pos)")
        if (tree_map[row_pos][col_pos]) {
            tree_count[i] += 1
        }
        
        col_pos = (col_pos + right[i]) % tree_map[row_pos].count
        row_pos = row_pos + down[i]
    }
}
var answer = tree_count.reduce(1, *)
tree_count.forEach {n in
    print(n.description)
}
print("\(tree_count) trees")

print("Answer is \(answer)")


