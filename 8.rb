#!/usr/bin/env ruby
FILE = File.readlines('input/8.txt').map(&:strip)
DIGITS = [6, 2, 5, 5, 4, 5, 6, 3, 7, 6]
UNIQUE_DIGITS = [DIGITS[1], DIGITS[4], DIGITS[7], DIGITS[8]]

def part_1
  allowed_numbers = 0
  FILE.each do |line|
    _, numbers = line.split('|').map(&:strip)
    numbers.split(' ').map(&:strip).each do |num_code|
      allowed_numbers += 1 if UNIQUE_DIGITS.include?(num_code.length)
    end
  end

  allowed_numbers
end

def part_2
  decoded_numbers = []

  FILE.each do |line|
    output_for_this_line = []
    config, output = line.split('|').map(&:strip)

    digit_config = Array.new(10, [])
    config = config.split(' ').map(&:strip)
    config.each do |pattern|
      # First get all the numbers we know
      if UNIQUE_DIGITS.include?(pattern.length)
        code = pattern.split('').sort

        # Probably a better way of doing this!
        case pattern.length
        when DIGITS[1]
          digit_config[1] = code
        when DIGITS[4]
          digit_config[4] = code
        when DIGITS[7]
          digit_config[7] = code
        when DIGITS[8]
          digit_config[8] = code
        else
          raise 'Unknown number'
        end
      end
    end

    all = digit_config[8]
    right_two = digit_config[1]
    top = digit_config[7] - right_two
    middle_and_left_top = digit_config[4] - right_two

    # Find 3
    digit_config[3] = config.select do |p| 
      p.length === DIGITS[3] && (right_two - p.split('')).empty?
    end.first.split('').sort

    left_two = all - digit_config[3]
    left_top = middle_and_left_top - digit_config[3]
    left_bottom = left_two - left_top

    digit_config[9] = all - left_bottom

    # Find 2 and 5
    config.select do |p|
      p.length === DIGITS[2] && p.split('').sort != digit_config[3]
    end.each do |pattern|
      
      code = pattern.split('').sort

      if (left_top - code).empty?
        digit_config[5] = code
      elsif (left_bottom - code).empty?
        digit_config[2] = code
      else
        raise 'Unknown number'
      end
    end

    right_top = right_two - digit_config[5]
    digit_config[6] = all - right_top

    # Find 0
    digit_config[0] = config.select do |p| 
      p.length === DIGITS[0] && (right_two - p.split('')).empty? && (left_two - p.split('')).empty?
    end.first.split('').sort

    middle = all - digit_config[0]
    right_bottom = right_two - digit_config[2]
    bottom = all - digit_config[4] - top - left_bottom

    # Draw number if needed
    # puts " #{top}#{top} "
    # puts "#{left_top}  #{right_top}"
    # puts "#{left_top}  #{right_top}"
    # puts " #{middle}#{middle} "
    # puts "#{left_bottom}  #{right_bottom}"
    # puts "#{left_bottom}  #{right_bottom}"
    # puts " #{bottom}#{bottom} "

    output.split(' ').map(&:strip).each do |num_code|
      number = nil
      digit_config.each_with_index do |code, i|
        if num_code.split('').sort == code
          number = i
          break
        end
      end
      raise 'No match found' unless number
      output_for_this_line << number
    end

    decoded_numbers << output_for_this_line.join.to_i
  end

  decoded_numbers.sum
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end