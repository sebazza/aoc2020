import strutils
import algorithm
import tables
import os



var adapters: seq[int]
adapters.add(0)   # Wall joltage

let filename = paramStr(1)

for line in filename.lines:
    adapters.add(parseInt(line))

adapters.sort()

let my_joltage = adapters[adapters.high()] + 3
adapters.add(my_joltage) # My device joltage

for i in adapters:
    echo i


var difference = initCountTable[int]()

for i, joltage in adapters.pairs:
    echo joltage
    if i < len(adapters) - 1:
        echo adapters[i + 1], " - ", joltage, " = ", adapters[i + 1] - joltage
        difference.inc(adapters[i + 1] - joltage)   


for d, n in difference.pairs:
    echo d, " occurred ", n, " times"

echo "Answer part one: ", difference[1] * difference[3]



var count: seq[int]
count.add(1)
for i, joltage in adapters.pairs:
    
    if i > 0:
        count.add(count[i - 1])
    if i >= 2 and joltage - adapters[i - 2] <= 3:
        count[i] += count[i - 2]
    if i >= 3 and joltage - adapters[i - 3] <= 3:
        count[i] += count[i - 3]
    echo "Adapter ", i, " with ", joltage, " jolts, " , count[i], " times"

#echo count



