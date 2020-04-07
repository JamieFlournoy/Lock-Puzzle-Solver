#!/usr/bin/env ruby -w

# Copyright 2020, Jamie Flournoy, All rights reserved.
#
# This is a brute-force solver for the "Can you crack the lock code?"
# "Can you open the lock using these clues?" puzzle.
#
# The puzzle states that for a 3-digit combination lock, where each
# digit is a value between 0 and 9, the following clues are known
# about certain combinations:
# Combination  Result
# 6-8-2        "One digit is right and in its place"
# 6-1-4        "One digit is right but in the wrong place"
# 2-0-6        "Two digits are right, but both are in the wrong place"
# 7-3-8        "All digits are wrong"
# 3-8-0        "One digit is right but in the wrong place"
#
# It has been years since I last wrote Ruby code professionally, but I
# really enjoyed using it, so I decided to dust off my rusty Ruby
# skills today and write a concicse, fairly idiomatic program to
# brute-force a solution to this puzzle. Here it is.
#
# If you aren't familiar with downloading a script to run on your
# computer, just save this as "lockpuzzle.rb" and run it via:
#
# ruby lockpuzzle.rb
#
# This requires that you have Ruby already installed, which you do if
# you have a Mac and probably also for any Linux based OS you might
# have.
#
# Alternatively, you can run it in an online interpreter. Go to
# https://www.tutorialspoint.com/execute_ruby_online.php and paste
# this whole thing in and click "Execute" (near the upper left corner
# of the page) to run it and see the output.


# ex. [1,2,3], [3,2,1] => [false, true, false]
def matches_in_place(a, b)
  a.map.with_index{|e,i| e == b[i]}
end

def num_matches_in_place(a, b)
  matches_in_place(a,b).reduce(0){|total, elem| total + (elem ? 1 : 0)}
end

def num_digits_right(a, b)
  # Return the number of elements in the intersection of a and b.
  (a & b).length
end

def rule1?(guess)
  clue_combo = [6,8,2]
  num_matches_in_place(guess, clue_combo) == 1 and num_digits_right(guess, clue_combo) == 1
end

def rule2?(guess)
  clue_combo = [6,1,4]
  num_matches_in_place(guess, clue_combo) == 0 and num_digits_right(guess, clue_combo) == 1
end

def rule3?(guess)
  clue_combo = [2,0,6]
  num_matches_in_place(guess, clue_combo) == 0 and num_digits_right(guess, clue_combo) == 2
end

def rule4?(guess)
  clue_combo = [7,3,8]
  num_digits_right(guess, clue_combo) == 0
end

def rule5?(guess)
  clue_combo = [3,8,0]
  num_matches_in_place(guess, clue_combo) == 0 and num_digits_right(guess, clue_combo) == 1
end

def print_guess(guess)
  print "%d-%d-%d" % guess
end

def evaluate(guess)
  print_guess guess
  print ":"
  fails = 0
  fail = lambda do |rule_num|
    print"  !r%d" % [rule_num]
    fails += 1
  end
  report_result = lambda do |rule_num, rule_result|
    if rule_result
      print "    "
    else
      fail.call rule_num
    end
  end
  # Do not short-circuit failures - evaluate all of the rules even if
  # some fail.
  report_result.call(1, rule1?(guess))
  report_result.call(2, rule2?(guess))
  report_result.call(3, rule3?(guess))
  report_result.call(4, rule4?(guess))
  report_result.call(5, rule5?(guess))
  print " OMG OK!!11!" if fails == 0
  puts
  fails == 0
end

valid_guesses = []
for i in 0..9
  for j in 0..9
    for k in 0..9
      guess = [i,j,k]
      success = evaluate guess
      if success
        valid_guesses.push guess
      end
    end
  end
end

if valid_guesses.empty?
  puts "No valid guesses found. :("
else
  puts "\nValid guesses:"
  valid_guesses.each do |valid|
    print_guess valid
    puts
  end
end
