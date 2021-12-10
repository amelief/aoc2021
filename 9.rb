#!/usr/bin/env ruby
FILE = File.readlines('input/9.txt').map(&:strip)

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

BASIC_DIRECTIONS = DIRECTIONS.slice(:top, :right, :bottom, :left)

$points = FILE.clone

def prevent_negative_pointer(value)
  value < 0 ? nil : value
end

def prevent_overflow_pointer(value)
  value >= FILE.size ? nil : value
end

def points_adjacent_to(row, column, return_points = true, use_basic: true)
  points_around = []

  BASIC_DIRECTIONS.each do |direction, coords|
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

    point_found = FILE[new_row][new_column]
    next if point_found.nil?

    points_around << point_found.to_i if point_found
  end

  points_around.compact
end

def alt_points_adjacent_to(row, column, lowest, current)
  points_around = []
  points_with_positions = []

  BASIC_DIRECTIONS.each do |direction, coords|
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
    next if $already_mapped.include?([new_row, new_column])

    point_found = FILE[new_row][new_column]
    next if point_found.nil?

    if point_found
      point_found = point_found.to_i
      if point_found < 9 && point_found > lowest 
        points_around << point_found
        points_with_positions << [new_row, new_column]
        $already_mapped << [new_row, new_column]
      end
    end
  end

  [points_with_positions.compact, points_around.compact]
end

def lowest_points(return_positions = false)
  minimum_points = []
  points_with_positions = []

  FILE.each_with_index do |the_row, row|
    0.upto(the_row.length - 1) do |column|
      current_value = the_row[column].to_i
      if current_value < points_adjacent_to(row, column).min
        minimum_points << current_value
        points_with_positions << { position: [row, column], value: current_value }
      end
    end
  end

  return_positions ? points_with_positions : minimum_points
end

def part_1
  lowest_points.sum + lowest_points.count
end

def part_2
  positions = lowest_points(true).map { |p| p[:position] }
  $already_done = []
  $already_mapped = []
  all_basins = []

  positions.each do |row, column| 
    lowest = current = FILE[row][column].to_i

    found_points = [[lowest]]
    positions_to_check = [[row, column]]

    while positions_to_check.any? do
      positions_to_check.each do |position|
        current = FILE[position[0]][position[1]].to_i
        points, ns = alt_points_adjacent_to(position[0], position[1], lowest, current)
        found_points << ns

        positions_to_check += points

        $already_done << position
        $already_done.uniq!

        positions_to_check -= $already_done
        positions_to_check.uniq!
      end
    end

    pp = found_points.compact.flatten

    all_basins << pp.size
  end

  all_basins = all_basins.sort.reverse

  all_basins.take(3).reduce(&:*)
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end