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

def points_adjacent_to(row, column, use_basic: true)
  points_around = {}

  directions_to_use = use_basic ? BASIC_DIRECTIONS : DIRECTIONS

  directions_to_use.each do |direction, coords|
    x, y = coords
    new_row = row.dup
    new_column = column.dup

    point_found = nil

    while point_found.nil?
      new_row += x
      new_column += y

      new_row = prevent_negative_pointer(new_row)
      new_row = prevent_overflow_pointer(new_row) if new_row
      new_column = prevent_negative_pointer(new_column)

      break if new_row.nil? || new_column.nil?

      point_found = FILE[new_row][new_column]
      break if point_found.nil?
    end

    points_around[direction] = point_found.to_i if point_found
  end

  points_around.compact
end

def recursive_points_adjacent_to(row, column, current, lowest)
  points_around = []
  positions_done = []
  lowest = lowest.to_i
  current = current.to_i

  return if last_done.include? [row, column]

  directions_to_use = BASIC_DIRECTIONS

  directions_to_use.each do |direction, coords|
    x, y = coords
    new_row = row.dup
    new_column = column.dup

    point_found = nil

    while point_found.nil?
      new_row += x
      new_column += y

      new_row = prevent_negative_pointer(new_row)
      new_row = prevent_overflow_pointer(new_row) if new_row
      new_column = prevent_negative_pointer(new_column)

      break if new_row.nil? || new_column.nil?

      point_found = FILE[new_row][new_column]
      break if point_found.nil?
    end

    puts point_found.inspect

    if point_found
      point_found = point_found.to_i
      if point_found < 9 && point_found > lowest && 
        (point_found == (current + 1) || point_found == (current - 1))
        points_around << point_found
        puts "Recursing with: #{new_row}, #{new_column} - #{point_found} #{lowest}"
        recursive_points_adjacent_to(new_row, new_column, point_found, lowest)
      end
    end
  end

  points_around.compact
end


def lowest_points(return_positions = false)
  minimum_points = []
  points_with_positions = []

  FILE.each_with_index do |the_row, row|
    0.upto(the_row.length - 1) do |column|
      current_value = the_row[column].to_i
      if current_value < points_adjacent_to(row, column).values.min
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
  a = []
  positions.each do |row, column|
    $already_done = 
    puts "Position: #{row},#{column}"
    a << recursive_points_adjacent_to(row, column, FILE[row][column], FILE[row][column])
  end

  puts a.inspect
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end