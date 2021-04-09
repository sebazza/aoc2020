import sys
import fileinput
from collections import deque




    


def infix_to_postfix(line, precedence_rule):

    operators = []
    output = deque()
    tokens = line.strip().split(" ")

    for t in tokens:
        # Digit: push value onto output queue
        if t.isdigit():
            output.append(int(t))
        # Open brackets: Push onto operator stack.
        elif t.startswith("("):
            tmp = t
            while tmp.startswith("("):
                operators.append("(")
                tmp = tmp[1:len(t)]
            output.append(int(tmp))
        # Close brackets: Pop operator stack onto output until open bracket is
        # found.
        elif t.endswith(")"):
            output.append(int(t[0:t.index(")")]))
            tmp = t
            while tmp.endswith(")"):         
                op = operators.pop()
                while op != "(":
                    output.append(op)
                    if (len(operators) > 0):
                        op = operators.pop()
                    else:
                        break
                tmp = tmp[0:-1]
        # Operator: if operators of greater precedence on operator stack, pop
        # them off onto the output queue. Stop at open bracket.
        elif t == "*" or t == "+":
            while len(operators) > 0 and \
                precedence_rule(operators[len(operators) - 1], t) and \
                operators[len(operators) - 1] != "(":
                    output.append(operators.pop())
            operators.append(t)
    while len(operators) > 0:
        output.append(operators.pop())

    return output




def no_precedence(op1, op2):
    return True



def is_greater_precedence(op1, op2):
    if op1 == "+":
        return op2 == "*"
    if op1 == "*":
        return op2 == "*"

    return True



# Evaluate 
def evaluate_rpn(rpn):

    stack = []
    print("Evaluating", rpn)

    while len(rpn) > 0:
        a = rpn.popleft()
        if isinstance(a, int):
            stack.append(a)
        elif a == "+":
            first = stack.pop()
            second = stack.pop()
            stack.append(first + second)
        elif a == "*":
            first = stack.pop()
            second = stack.pop()
            stack.append(first * second)
    result = stack.pop()
    print(result)
    return result



def read_file(filename):

    sum1 = 0
    sum2 = 0
    # File has three section
    with fileinput.input(files=(filename)) as f:
        for line in f:
            if (line.strip()):
                rpn_stack1 = infix_to_postfix(line, no_precedence)
                rpm_stack2 = infix_to_postfix(line, is_greater_precedence)
                sum1 += evaluate_rpn(rpn_stack1)
                sum2 += evaluate_rpn(rpm_stack2)


    return sum1, sum2



def main():

    print(read_file(sys.argv[1]))






if __name__ == '__main__':
    main()


