#!/usr/bin/env ruby
FILE = File.readlines('input/3.txt').map(&:strip)
ZERO = 0
ONE = 1

def decimalise(binary_string)
  binary_string.reverse.chars.map.with_index do |bit, i|
    bit.to_i * (2 ** i)
  end.sum
end

def part_1
  number_of_bits = FILE.first.split('').count

  gamma_pattern = ''
  epsilon_pattern = ''

  number_of_bits.times do |position|
    zeros = 0
    ones = 0

    FILE.each do |line|
      line[position].to_i === ZERO ? (zeros += 1) : (ones += 1)
    end

    if ones > zeros
      gamma_pattern += ONE.to_s
      epsilon_pattern += ZERO.to_s
    else
      epsilon_pattern += ONE.to_s
      gamma_pattern += ZERO.to_s
    end
  end

  decimalise(gamma_pattern) * decimalise(epsilon_pattern)
end

def part_2
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end