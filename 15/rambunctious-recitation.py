import sys


starting_input = []
test_starting_inputs = [[1, 3, 2], [0, 3, 6], [2, 1, 3], [1, 2, 3], [2, 3, 1], [3, 2, 1], [3, 1, 2], [19, 0, 5, 1, 10, 13]]

number_last_turns = {}


# Log number and previous two occurences.
def speak(turn, number):

    global number_last_turns
    #print("Speak:", number)
    number_last_turns[number] = (turn, number_last_turns.get(number, (0, 0))[0])
    return number



# Check whether number has already been spoken
def already_spoken(number):

    global number_last_turns

    return number in number_last_turns



def main():

    global starting_test_inputs
    global number_last_turns



    for starting_input in test_starting_inputs:
        number_last_turns.clear()

        # Starting numbers
        for index, number in enumerate(starting_input, 1):
            last_number = speak(index, number)
        #print(number_last_turns)

        if 0 in starting_input:
            first_0 = False
        else:
            first_0 = True

        last_number_first_spoken = True
        turn = len(starting_input) + 1
        while turn < 30000001:
            #print("Last number spoken is ", last_number)

            if last_number_first_spoken == True:
                # First time previous turn's number was spoken.
                #print("First time hearing ", last_number)
                last_number = speak(turn, 0)
                if first_0:  # O is a special case.
                    last_number_first_spoken = True
                    first_0 = False
                else:
                    last_number_first_spoken = False
            else:
                last_turns_spoken = number_last_turns.get(last_number)
                #print ("Last turns spoken are", last_turns_spoken)
                number_age = last_turns_spoken[0] - last_turns_spoken[1]

                if number_age < 1:
                    print("oh oh")
                if already_spoken(number_age) == False:
                    last_number_first_spoken = True
                last_number = speak(turn, number_age)
                
            #print(number_last_turns)
            #print("Turn " , turn, "is", last_number)
            turn += 1
            #print()

        print("For ", starting_input, "2020th number is", last_number)
    

if __name__ == '__main__':
    main()