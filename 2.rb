#!/usr/bin/env ruby
FILE = File.readlines('input/2.txt').map(&:strip)

NEGATIVE = 'up'
X = 'forward'
Y = 'down'

def part_1
  x_pos = 0
  y_pos = 0

  FILE.each do |line|
    instruction, num = line.split(' ')

    num = num.to_i
    num = -num if instruction == NEGATIVE

    if instruction == X
      x_pos += num
    else
      y_pos += num
    end
  end

  x_pos * y_pos
end

def part_2
  x_pos = 0
  y_pos = 0
  aim = 0

  FILE.each do |line|
    instruction, num = line.split(' ')

    num = num.to_i

    case instruction
    when NEGATIVE
      aim += -num
    when Y
      aim += num
    when X
      x_pos += num
      y_pos += (aim * num)
    end
  end

  x_pos * y_pos
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end