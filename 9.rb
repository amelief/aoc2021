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
  points_around = {}
  points_with_positions = []

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

    if point_found
      points_with_positions << { position: [new_row, new_column], value: point_found.to_i }
    end

    points_around[direction] = point_found.to_i if point_found
  end

  (return_points ? points_around.compact : points_with_positions)
end

def recursive_points_adjacent_to(row, column, current, lowest)
  points_around = []
  positions_done = []
  lowest = lowest.to_i
  current = current.to_i

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
      break if $already_done.include?([new_row, new_column, current])

      point_found = FILE[new_row][new_column]
      break if point_found.nil?
    end

    puts point_found.inspect

    if point_found
      point_found = point_found.to_i
      if point_found < 9 && point_found > lowest && 
        (point_found == (current + 1) || point_found == (current - 1))
        points_around << point_found
        $already_done << [row, column, current]
        puts "Recursing with: #{new_row}, #{new_column} - #{point_found} #{lowest}"
        recursive_points_adjacent_to(new_row, new_column, point_found, lowest)
      end
    end
  end

  points_around.compact
end


def alt_points_adjacent_to(row, column, lowest, current)
  #puts "Points around row #{row}, column #{column}"
  points_around = []
  points_with_positions = []

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
      break if $already_mapped.include?([new_row, new_column])

      point_found = FILE[new_row][new_column]
      break if point_found.nil?
    end

    if point_found
      point_found = point_found.to_i
      if point_found < 9 && point_found > lowest && 
        (point_found == (current + 1) || point_found == (current - 1))
          #puts "Found point: #{point_found}"
          points_around << point_found
          points_with_positions << [new_row, new_column]
          $already_mapped << [new_row, new_column]
      else
        "No point, point was #{point_found}"
      end
    end

    #puts "#{row},#{column} : #{new_row},#{new_column} - These are the points: #{points_with_positions.inspect}, #{points_around.inspect}"

    #points_around[direction] = point_found.to_i if point_found
  end

  [points_with_positions.compact, points_around.compact]
end

def lowest_points(return_positions = false)
  minimum_points = []
  points_with_positions = []

  FILE.each_with_index do |the_row, row|
    0.upto(the_row.length - 1) do |column|
      current_value = the_row[column].to_i
      if current_value < points_adjacent_to(row, column, true).values.min
        minimum_points << current_value
        points_with_positions << { position: [row, column], value: current_value }
      end
    end
  end

  return_positions ? points_with_positions : minimum_points
end

def part_1
  #lowest_points.sum + lowest_points.count
end

def part_2
  positions = lowest_points(true).map { |p| p[:position] }
  #lowest = lowest_points(true).map { |p| p[:value] }
  $already_done = []
  $already_mapped = []
  all_basins = []

  positions.each do |row, column| # = positions[3]
    lowest = current = FILE[row][column].to_i
    #puts "Lowest is #{lowest}"

    found_points = [[lowest]]
    positions_to_check = [[row, column]]
    #1.upto(10) do 
    while positions_to_check.any? do
      #positions_to_check.delete_at(0)
      positions_to_check.each do |position|
        #puts position.inspect
        current = FILE[position[0]][position[1]].to_i
        points, ns = alt_points_adjacent_to(position[0], position[1], lowest, current)
        found_points << ns

        positions_to_check += points #.map { |x| x[:position] }
        #puts "New positions: #{positions_to_check.inspect}"
        $already_done << position
        $already_done.uniq!
        #puts "Already done: #{$already_done.inspect}"
        positions_to_check -= $already_done
        positions_to_check.uniq!


        #puts "Positions to check: " + positions_to_check.inspect
      end
    end

    pp = found_points.compact.flatten

    all_basins << pp.size
  end

  all_basins = all_basins.sort.reverse

  points = all_basins[0]
  1.upto(2) do |x|
    points *= all_basins[x]
  end

  points

  #puts all_basins.inspect
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end