# Advent of code: day 6. Custom customs
#

all_answers = []       # Array of all answers for each group (array).
unaminous_answers = [] # Array of all unaminous answers (for part two) 
# Read each line for file.
# As we read file, accumulate answers into groups
File.open("input.txt", 'r') do |f|
    group_answers = ""
    group_unanimous_answers = nil
    while line = f.gets  # Each line is a passengers anwers.
        if line != "\n"
            group_answers = group_answers + line.strip  # Accumulate answers for the group.
            if group_unanimous_answers == nil
                group_unanimous_answers = line.strip.chars
            else
                # Intersection of new answers with previous for the group.
                group_unanimous_answers = group_unanimous_answers & line.strip.chars
            end
        else
            # Add group answers to arrays.
            all_answers << group_answers.chars
            unaminous_answers << group_unanimous_answers
            group_answers = ""
            group_unanimous_answers = nil
        end
    end
    # Last group.
    if group_answers != ""
        all_answers << group_answers.chars
        unaminous_answers << group_unanimous_answers
    end
end

# Find unique answers for each group.
uniq_answers = all_answers.map {|a| a.uniq }

#print uniq_answers
#print unaminous_answers

print "Number of groups: #{uniq_answers.count}\n"

# Sum unique answers for each group (answer for part one)
total = uniq_answers.reduce(0) { |sum, a| sum + a.count }
# Sum unaminous answers for each group (answer for part two)
total_unanimous = unaminous_answers.reduce(0) { |sum, a| sum + a.count }

print "Answer to part one: total #{total}\n"
print "Answer to part two: total #{total_unanimous}\n"

