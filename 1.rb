#!/usr/bin/env ruby
FILE = File.readlines('input/1.txt').map(&:to_i)

def number_increased?(number, counter, source = FILE)
  false if counter < 1
  number > source[counter - 1].to_i
end

def part_1
  increases = 0

  FILE.each_with_index do |n, i|
    increases += 1 if number_increased?(n, i)
  end

  increases
end

def part_2
  sums = []
  increases = 0

  FILE.each_with_index do |n, i|
    three_numbers = [n]
    
    1.upto(2) do |j|
      three_numbers << FILE[i + j].to_i rescue nil
    end

    break if three_numbers.empty?

    sums << three_numbers.sum
  end

  sums.each_with_index do |n, i|
    increases += 1 if number_increased?(n, i, sums)
  end

  increases
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end