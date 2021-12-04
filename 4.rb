#!/usr/bin/env ruby
FILE = File.read('input/4.txt').split("\n\n").map(&:strip)

NUMBERS = FILE[0].split(',').map(&:to_i)

RAW_BOARDS = FILE.drop(1)

$called_numbers = []

def remaining_numbers(array_to_use, matching_line)
  remaining = []
  array_to_use[matching_line] = nil
  array_to_use.compact.each do |s|
    remaining << s - $called_numbers
  end
  remaining.flatten.sum
end


def check_lines(lines)
  lines.each_with_index do |line, i|
    return nil unless $called_numbers.count >= line.count

    remaining = line - $called_numbers

    if remaining.empty?
      return i
    else
      next
    end
  end
  nil
end

def check_board(raw_board)
  x_lines = []
  y_lines = []
  matched_line = nil

  raw_board.split("\n").map(&:strip).map.each_with_index do |line, i|
    x_lines[i] = line.split(' ').compact.map(&:to_i)
  end

  x_lines.each_with_index do |line, i|
    line.each_with_index do |num, j|
      y_lines[j] ||= []
      y_lines[j][i] = num
    end
  end

  x_match = check_lines(x_lines)
  y_match = check_lines(y_lines)

  if x_match || y_match
    if !x_match.nil? && !y_match.nil?
      matched_line = (x_match <= y_match ? x_match : y_match)
    elsif !x_match.nil? && y_match.nil?
      matched_line = x_match
    elsif !y_match.nil? && x_match.nil?
      matched_line = y_match
    end

    x_or_y = (matched_line == x_match ? 'x' : 'y')

    return remaining_numbers(eval("#{x_or_y}_lines"), matched_line)
  else
    nil
  end
end


def part_1
  match_found = false
  NUMBERS.each do |number|
    break if match_found === true
    $called_numbers << number
  
    RAW_BOARDS.each_with_index do |board, i|
      next if match_found === true
      remaining_sum = check_board(board)

      unless remaining_sum.nil?
        match_found = true
        return remaining_sum * $called_numbers.last
      else
      end
    end
  end
end

def part_2
  winning_scores = []
  last_win = nil

  NUMBERS.each do |number|
    $called_numbers << number
  
    RAW_BOARDS.each_with_index do |board, i|
      next unless winning_scores[i].nil?
      remaining_sum = check_board(board)

      unless remaining_sum.nil?
        last_win = winning_scores[i] = remaining_sum * $called_numbers.last
      end
    end
  end

  last_win
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end