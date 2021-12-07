#!/usr/bin/env ruby
FILE = File.readlines('input/3.txt').map(&:strip)
BITS = FILE.first.split('').count
ZERO = 0
ONE = 1

def decimalise(binary_string)
  binary_string.reverse.chars.map.with_index do |bit, i|
    bit.to_i * (2 ** i)
  end.sum
end

def calculate_gamma_epsilon
  gamma_pattern = ''
  epsilon_pattern = ''

  BITS.times do |position|
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

  [gamma_pattern, epsilon_pattern]
end

def calculate_rating(array, position, higher: true)
  zero_numbers = []
  one_numbers = []

  array.each do |line|
    line[position].to_i === ZERO ? (zero_numbers << line) : (one_numbers << line)
  end

  if higher == true
    one_numbers.count >= zero_numbers.count ? one_numbers : zero_numbers
  else
    one_numbers.count < zero_numbers.count ? one_numbers : zero_numbers
  end
end

def calculate_o2_co2(higher = true)
  rating = FILE.clone

  BITS.times do |position|
    rating = calculate_rating(rating, position, higher: higher)
    break if rating.count === 1
  end

  rating.first
end

def part_1
  gamma_pattern, epsilon_pattern = calculate_gamma_epsilon

  decimalise(gamma_pattern) * decimalise(epsilon_pattern)
end

def part_2
  decimalise(calculate_o2_co2) * decimalise(calculate_o2_co2(false))
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end