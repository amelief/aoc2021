#!/usr/bin/env ruby
FILE = File.read('input/7.txt').split(',').map(&:to_i)
HIGHEST = FILE.max

def calculate_fuel(number)
end


def part_1
  possible_points = []

  0.upto(HIGHEST) do |i|
    possibles = []
    FILE.each do |number|
      possibles << ([number, i].max - [number, i].min)
    end
    possible_points[i] = possibles.sum
  end

  possible_points.min
end

def part_2
  possible_points = []

  0.upto(HIGHEST) do |i|
    possibles = []
    FILE.each do |number|
      fuel = 0
      steps = ([number, i].max - [number, i].min)
      1.upto(steps) do |step|
        fuel += step
      end if steps > 0
      possibles << fuel
    end
    possible_points[i] = possibles.sum
  end

  possible_points.min
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end