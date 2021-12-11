#!/usr/bin/env ruby

#This is extremely rough and messy but I had a lot of problems with it!

FILE = File.readlines('input/11.txt').map(&:strip).freeze

DIRECTIONS = {
  top: [-1, 0],
  top_right: [-1, 1],
  right: [0, 1],
  bottom_right: [1, 1],
  bottom: [1, 0],
  bottom_left: [1, -1],
  left: [0, -1],
  top_left: [-1, -1]
}

ALL_FLASH = [
'0000000000',
'0000000000',
'0000000000',
'0000000000',
'0000000000',
'0000000000',
'0000000000',
'0000000000',
'0000000000',
'0000000000'
]

def prevent_negative_pointer(value)
  value < 0 ? nil : value
end

def prevent_overflow_pointer(value)
  value >= FILE.size ? nil : value
end

def points_adjacent_to(row, column, array)
  points_around = []
  points_with_positions = []

  DIRECTIONS.each do |direction, coords|
    x, y = coords
    new_row = row.dup
    new_column = column.dup

    point_found = nil

    new_row += x
    new_column += y

    new_row = prevent_negative_pointer(new_row)
    new_row = prevent_overflow_pointer(new_row) if new_row
    new_column = prevent_negative_pointer(new_column)

    next if new_row.nil? || new_column.nil?

    point_found = array[new_row][new_column]
    next if point_found.nil?

    if point_found
      point_found = point_found.to_i

      if point_found == 9
        array[new_row][new_column] = point_found = 0.to_s
        $turned_to_0_this_turn << [new_row, new_column]
        points_around << point_found
        points_with_positions << [new_row, new_column]
      elsif point_found > 0 || 
        (point_found == 0 && !$turned_to_0_this_turn.include?([new_row, new_column]))
        array[new_row][new_column] = (array[new_row][new_column].to_i + 1).to_s
      end
    end
  end

  [array, points_with_positions.compact, points_around.compact]
end

def do_calculations(part)
  new_positions = FILE.clone.map(&:clone)

  flashes = 0
  step = 0

  while(new_positions != ALL_FLASH) do
    break if part == 1 && step == 100
    step += 1
    already_done = []
    positions_to_check = []

    $turned_to_0_this_turn = []

    new_positions.each_with_index do |row_data, row|
      row_data.each_char.with_index do |column_data, column|

        if new_positions[row][column].to_i == 9
          flashes += 1
          new_positions[row][column] = column_data = 0.to_s
          $turned_to_0_this_turn << [row, column]
          positions_to_check << [row, column]
        elsif new_positions[row][column].to_i > 0 || 
         (new_positions[row][column].to_i == 0 && !$turned_to_0_this_turn.include?([row, column]))
          new_positions[row][column] = column_data = (new_positions[row][column].to_i + 1).to_s
        end

        while positions_to_check.any? do
          positions_to_check.each do |position|

            new_positions, points, ns = points_adjacent_to(position[0], position[1], new_positions)

            positions_to_check += points
            flashes += ns.flatten.size

            already_done << position
            already_done.uniq!

            positions_to_check -= already_done
            positions_to_check.uniq!
          end
        end
      end
    end
  end
  (part == 1 ? flashes : step)
end

def part_1
  do_calculations(1)
end

def part_2
  do_calculations(2)
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end