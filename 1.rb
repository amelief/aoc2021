#!/usr/bin/env ruby
FILE = File.readlines('input/1.txt').map(&:to_i)

def part_1
  increases = 0

  FILE.each_with_index do |n, i|
    next if i < 1
    increases += 1 if n > FILE[i-1].to_i
  end

  increases
end

def part_2
  sums = []
  increases = 0

  FILE.each_with_index do |n, i|
    three_numbers = [n, FILE[i+1].to_i, FILE[i+2].to_i] rescue []

    break if three_numbers.empty?

    sums << three_numbers.sum
  end

  sums.each_with_index do |n, i|
    next if i < 1
    increases += 1 if n > sums[i-1].to_i
  end

  increases
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end