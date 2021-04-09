import fileinput
import sys
from functools import reduce


part_one_memory = {}
part_two_memory = {}
value_mask_0 = 0xFFFFFFFFFF  # Set 36 bits to 1
value_mask_1 = 0
memory_mask_0 = 0xFFFFFFFFFF  # Set 36 bits to 1
memory_mask_1 = 0
memory_mask_x = 0

# Read input file; parse into bus timetable and initial departure time
def read_input(filename):

	instructions = []
	with fileinput.input(files=(filename)) as f:
		for line in f:
			instructions.append(line.strip())
	return instructions



def set_mask(s):

	global value_mask_0
	global value_mask_1
	global memory_mask_0
	global memory_mask_1
	global memory_mask_x

	value_mask_0 = 0xFFFFFFFFFF  # Set 36 bits to 1
	value_mask_1 = 0
	memory_mask_0 = 0xFFFFFFFFFF  # Set 36 bits to 1
	memory_mask_1 = 0	
	memory_mask_x = 0

	for i, c in enumerate(s[::-1]):
		if c == 'X':
			memory_mask_x |= (1 << i)
			pass
		elif c == '1':
			value_mask_1 |= (1 << i)
			memory_mask_1 |= (1 << i)
		elif c == '0':
			value_mask_0 &= ~(1 << i)
			memory_mask_0  &= ~(1 << i)
			#print(format(value_mask_0,'b'))

	#print(s, value_mask_0, value_mask_1)
	print("New memory mask x is ", format(memory_mask_x,'b'))


def apply_value_mask(value):

	global value_mask_0
	global value_mask_1

	#print("Value before mask ", value_mask_0, value_mask_1, value)

	value &= value_mask_0  # Overwrite 0s
	value |= value_mask_1  # Overwrite 1s

	return value


def apply_memory_mask(address):

	global memory_mask_0
	global memory_mask_1
	global memory_mask_x

	addresses = list()
	print("Mask x = ", format(memory_mask_x,'b'), "to address", address)

	address |= memory_mask_1  # Only mask 1 applies for part two. Overwrite 1s
	addresses.append(address)
	mask_x = 1
	tmp = list()
	for i in range(36):
		if memory_mask_x & mask_x:
			print("Bit set")
			for a in addresses:
				tmp.append(a | mask_x)
				tmp.append(a & ~ mask_x)
			addresses = tmp.copy()
		mask_x = mask_x << 1
	print (" addresses are ", addresses)
	#for address in addresses:
		#print(format(address,'b'), address)
	return addresses


def main():

	global mask
	global part_one_memory
	global part_two_memory

	instructions = read_input(sys.argv[1])

	for instr in instructions:
		print("Instruction is", instr)
		s = instr.split(" = ")
		if s[0] == "mask":
			# Set mask
			set_mask(s[1])
		elif s[0].startswith("mem"):
			value = int(s[1])
			# Part one
			mem_loc = int(s[0][4:s[0].index(']')])
			print("Memory location is ", mem_loc)
			masked_value = apply_value_mask(value)
			#print(value)
			part_one_memory[mem_loc] = masked_value

			# Part two
			addresses = apply_memory_mask(mem_loc)
			for address in addresses:
				part_two_memory[address] = value


	#print(part_one_memory)

	part_one_total = sum(part_one_memory.values())
	part_two_total = sum(part_two_memory.values())
	print("Part one total = ", part_one_total)
	print("Part two total = ", part_two_total)




if __name__ == '__main__':
	main()