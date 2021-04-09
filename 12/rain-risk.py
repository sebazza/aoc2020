import fileinput
import sys
import math
from dataclasses import dataclass



@dataclass
class Coordinates:
	x: int
	y: int


# Part one: location of ship
class Location:
	
	c = Coordinates(0, 0)

	heading = 90 # Inital heading East.

	@property
	def x(self):
		return self.c.x

	@property
	def y(self):
		return self.c.y	

	def jumpNorth(self, d):
		self.c.y = self.c.y + d

	def jumpSouth(self, d):
		self.c.y = self.c.y - d

	def jumpEast(self, d):
		self.c.x = self.c.x + d

	def jumpWest(self, d):
		self.c.x = self.c.x - d

	def turnLeft(self, angle):
		self.heading = (self.heading + 360 - angle) % 360

	def turnRight(self, angle):
		self.heading = (self.heading + angle) % 360

	def moveForward(self, d):
		self.c.x = self.c.x + round(math.sin(self.heading / 180 * math.pi) * d)
		self.c.y  = self.c.y + round(math.cos(self.heading / 180 * math.pi) * d)

	def manhattanDistance(self):
		return math.fabs(self.x) + math.fabs(self.y)



# Part two: waypoint is relative to ship position.
class Waypoint:

	x = 10  # Initial E-W direction
	y = 1   # Inition N-S direction

	def jumpNorth(self, d):
		self.y = self.y + d

	def jumpSouth(self, d):
		self.y = self.y - d

	def jumpEast(self, d):
		self.x = self.x + d

	def jumpWest(self, d):
		self.x = self.x - d

	def turnLeft(self, angle):
		tmpx = self.x
		tmpy = self.y
		if angle == 90:
			self.x = tmpy * -1
			self.y = tmpx
		elif angle == 180:
			self.x = tmpx * -1
			self.y = tmpy * -1
		elif angle == 270:
			self.x = tmpy
			self.y = tmpx * -1

	def turnRight(self, angle):
		if angle == 90:
			self.turnLeft(270)
		elif angle == 180:
			self.turnLeft(180)
		elif angle == 270:
			self.turnLeft(90)
			




class Ship:

	c = Coordinates(0, 0)
	waypoint = None

	def setWaypoint(self, waypoint):
		self.waypoint = waypoint

	def moveForward(self, d):
		self.c.x = self.c.x + self.waypoint.x * d
		self.c.y = self.c.y + self.waypoint.y * d
		
	def manhattanDistance(self):
		return math.fabs(self.c.x) + math.fabs(self.c.y)



# Rules or part one
def doPartOneAction(action):
	return {
		'N': c.jumpNorth,
		'S': c.jumpSouth,
		'E': c.jumpEast,
		'W': c.jumpWest,
		'L': c.turnLeft,
		'R': c.turnRight,
		'F': c.moveForward,
	}.get(action)


# Rules for part two
def doPartTwoAction(action):
	return {
		'N': waypoint.jumpNorth,
		'S': waypoint.jumpSouth,
		'E': waypoint.jumpEast,
		'W': waypoint.jumpWest,
		'L': waypoint.turnLeft,
		'R': waypoint.turnRight,
		'F': ship.moveForward,
	}.get(action)


# Execute intructions
def travel(nav):
	for instruction in nav:
		#print(instruction)
		action, value = instruction[0], int(instruction[1:])
		doPartOneAction(action)(value)
		doPartTwoAction(action)(value)
		print("Part one", instruction, c.x, c.y)
		print("Part two:", instruction, "waypoint", ship.waypoint.x, ship.waypoint.y, "location", ship.c.x, ship.c.y)


# Read input file; parse into list of instructions
def read_input(filename):

	with fileinput.input(files=(filename)) as f:
		nav = [line.strip() for line in f]

	return nav


c = Location()
ship = Ship()
waypoint = Waypoint()
ship.setWaypoint(waypoint)

if __name__ == "__main__":

	print(sys.argv)
	nav = read_input(sys.argv[1])
	print(nav)
	travel(nav)

	print("Part one: manhattan distance = ", c.manhattanDistance())
	print("Part two: manhattan distance = ", ship.manhattanDistance())



