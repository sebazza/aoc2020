import fileinput
import sys
from math import gcd


departure_time = 0
timetable = []



# Read input file; parse into bus timetable and initial departure time
def read_input(filename):

	global departure_time
	global timetable
	with fileinput.input(files=(filename)) as f:
		departure_time = int(f.readline().strip())
		line = f.readline().strip()
		timetable = [(i, int(x)) for (i, x) in filter(lambda x: x[1] != 'x', enumerate(line.split(',')))]
	return


def lcm(number_list):
	lcm = 1
	for i in number_list:
		lcm = lcm * i // gcd(lcm, i)
	return lcm



def main():
	global departure_time
	global timetable
	leaving_times = {}
	read_input(sys.argv[1])
	print("timetable=", timetable)

	# Part one
	for time in timetable:
		t = time[1]
		leaving_times[t] = (departure_time - (departure_time % t) + t)
	earliest = min(leaving_times.items(), key=lambda x: x[1])
	print(earliest)
	wait_time = earliest[1] - departure_time
	bus_id = earliest[0]
	print("Answer for part one: ", wait_time, "x", bus_id, "=", wait_time * bus_id)

	# Part two
	time = 0 
	count = 0
	# Iterate over buses, checking departure times, looking for the sequence
	# of departure with one minute difference.
	while count < len(timetable):
		count = 0
		increment = 1
		# Check whether bus departs at time + index
		for bus in timetable:
			index = bus[0]
			bus_id = bus[1]
			departure_time = (time + index) - ((time + index) % bus_id)
			if departure_time != time + index:
				# No bus at this time
				break;
			else:
				# Increase increment to LCM of buses.
				increment = lcm([x[1] for x in timetable[:count + 1]])
				#print("increment is ", increment)
				count += 1
		time += increment




if __name__ == '__main__':
	main()