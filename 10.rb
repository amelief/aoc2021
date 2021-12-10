#!/usr/bin/env ruby
FILE = File.readlines('input/10.txt').map(&:strip)

BRACKETS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

AUTOCOMPLETE_POINTS = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

def parse_file
  illegal_chars = []
  illegal_lines = []
  autocompletes = []

  FILE.each_with_index do |line, j|
    expected_for_closing = []
    line.split('').each_with_index do |char, i|
      if BRACKETS.keys.include?(char)
        expected_for_closing << BRACKETS[char]
      else
        if char == expected_for_closing.last
          expected_for_closing.pop
        else
          illegal_chars << char
          illegal_lines << j
          break
        end
      end
    end

    autocompletes[j] = expected_for_closing.reverse.join
  end

  [illegal_chars, illegal_lines, autocompletes]
end

def part_1 
  points = 0
  parse_file[0].map { |char| points += POINTS[char] }
  points
end

def part_2
  new_lines = FILE.clone

  _, invalid_lines, autocompletes = parse_file

  invalid_lines.each do |line_no|
    new_lines[line_no] = nil
    autocompletes[line_no] = nil
  end

  new_lines.compact!
  autocompletes.compact!

  all_points = []
  autocompletes.each do |chars|
    points = 0
    chars.split('').each do |char|
      points *= 5
      points += AUTOCOMPLETE_POINTS[char]
    end

    all_points << points
  end
  
  all_points.sort!

  all_points[(all_points.size - 1) / 2]
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end