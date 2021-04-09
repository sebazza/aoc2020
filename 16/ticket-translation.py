import sys
import fileinput
from functools import reduce
import pprint

ticket_rules = {}
my_ticket  = []
nearby_tickets = []


def read_file(filename):

    global my_ticket
    global nearby_tickets
    global ticket_rules

    # File has three section
    with fileinput.input(files=(filename)) as f:
        
        # Rules:
        for line in f:
            if line != "\n":
                print(line)
                insert_rule(line.strip())
            else:
                break
        print("Ticket rules: ", ticket_rules)

        # My ticket
        f.readline()
        line = f.readline().strip()
        my_ticket = list(map(int, line.split(",")))
        print(my_ticket)

        f.readline()
        f.readline()
        
        # Nearby tickets
        for line in f:
            print(line)
            nearby_tickets.append(list(map(int, line.strip().split(","))))
        print(nearby_tickets)



def insert_rule(rule):

    global ticket_rules

    # Split once to get name
    (name, rules) = rule.split(":")

    ticket_rules[name] = []

    # Split again to get rules
    for r in rules.split(" or "):
        ticket_rules[name].append(tuple(map(int, r.split("-"))))


def check_number_against_rule(number, rule):
    # Rule consists of minimum and maximum
    minimum, maximum = rule
    if (number <= maximum) and (number >= minimum):
        print("Number", number, "is good")
        return True
    return False



def check_number(number):

    global ticket_rules

    for name, rules in ticket_rules.items():
        for r in rules:
            minimum, maximum = r
            #print("Checking ", number, "against maximum", maximum, "minimum", minimum)
            if check_number_against_rule(number, r):
                return True
    #print("Number", number, "is basds")
    return False


def check_ticket(ticket):

    for number in ticket:
        if check_number(number) == False:
            return False

    return True


def check_numbers():

    global nearby_tickets
    invalid_numbers = []
    for ticket in nearby_tickets:
        for number in ticket:
            if check_number(number) == False:
                invalid_numbers.append(number)

    #print("Invalid numbers", invalid_numbers)
    if len(invalid_numbers):
        print("Ticket scan error rate", reduce(lambda x, y: x + y, invalid_numbers))
    return invalid_numbers 


def find_valid_tickets():

    global nearby_tickets
    valid_tickets = []
    invalid_tickets = []

    for ticket in nearby_tickets:
        if check_ticket(ticket) == False:
            #print(ticket, "is invalid")
            invalid_tickets.append(ticket)
        else:
            valid_tickets.append(ticket)
    #print("Invalid ticket", invalid_tickets)
    #print("Valid tickets", valid_tickets)
    return valid_tickets


def find_fields(tickets):

    global ticket_rules
    global my_ticket

    fields = {}
    for i in range(len(ticket_rules)):
        is_good = False
        fields[i] = []
        for name, rules in ticket_rules.items():
            print("Checking numbers for field", name)
            for ticket in tickets:
                number = ticket[i]
                print("Checking number", number, "for position", i)
                for r in rules:  
                # Check against each rule, list which rules are good.           
                    print(name, r)
                    is_good = check_number_against_rule(number, r)
                    if is_good:
                        break
                if not is_good:
                    break
            if is_good:
                fields[i].append(name)
                print("Field ", i, "can be ", name)
                is_good = False

    pprint.pprint(fields)


    while True:
        removed_something = False
        for i, f in fields.items():
            if len(f) == 1:
                name = f[0]
                # Remove from other rows
                for j, g in fields.items():
                    if len(g) > 1:
                        try:
                            print("Remove", name, "from", j, g)
                            g.remove(name)
                            removed_something = True
                        except ValueError:
                            pass
                
        if not filter(lambda x: len(x) > 1, fields):
            break
        if removed_something == False:
            break


    pprint.pprint(fields)

    dep = dict(filter(lambda x: x[1][0].startswith("departure"), fields.items()))
    print(dep)

    s = 1
    for i, f in dep.items():
        s *= my_ticket[i]
    print(s)




def main():

    read_file(sys.argv[1])
    
    check_numbers()
    
    valid_tickets = find_valid_tickets()

    find_fields(valid_tickets)





    

if __name__ == '__main__':
    main()