#!/usr/bin/env ruby
FILE = File.readlines('input/5.txt').map(&:strip)

def map_verticals(vertical)
  vertical.each do |from, to|
    x1, y1 = from.split(',').map(&:to_i)
    x2, y2 = to.split(',').map(&:to_i)

    lowest = [y1, y2].min
    highest = [y1, y2].max

    lowest.upto(highest) do |y|
      $map[y][x1] += 1
    end
  end
end

def map_horizontals(horizontal)
  horizontal.each do |from, to|
    x1, y1 = from.split(',').map(&:to_i)
    x2, y2 = to.split(',').map(&:to_i)

    lowest = [x1, x2].min
    highest = [x1, x2].max

    lowest.upto(highest) do |x|
      $map[y1][x] += 1
    end
  end
end

def map_diagonals(diagonal)
  diagonal.each do |from, to|
    x1, y1 = from.split(',').map(&:to_i)
    x2, y2 = to.split(',').map(&:to_i)

    all_x_numbers = ([x1, x2].min..[x1, x2].max).to_a
    all_y_numbers = ([y1, y2].min..[y1, y2].max).to_a

    all_y_numbers.reverse! if y2 < y1
    all_x_numbers.reverse! if x2 < x1

    all_x_numbers.each_with_index do |x, i|
      $map[all_y_numbers[i]][x] += 1
    end
  end
end

def map_points(part)
  max_grid_size = 0
  vertical = []
  horizontal = []
  diagonal = []

  FILE.each do |coord_list|
    from, to = coord_list.split('->').map(&:strip)

    x1, y1 = from.split(',').map(&:to_i)
    x2, y2 = to.split(',').map(&:to_i)

    current_highest = [x1, x2, y1, y2].max
    max_grid_size = current_highest if current_highest > max_grid_size

    if x1 == x2
      vertical << [from, to]
    elsif y1 == y2
      horizontal << [from, to]
    else
      diagonal << [from, to]
    end
  end

  0.upto(max_grid_size) do |x|
    $map[x] = []
    0.upto(max_grid_size) do |y|
      $map[x][y] = 0
    end
  end

  map_verticals(vertical)
  map_horizontals(horizontal)

  map_diagonals(diagonal) if part == 2

  #draw_map

  overlapping = 0
  $map.compact.each do |x|
    x.compact.each do |y|
      overlapping += 1 if y > 1
    end
  end
  overlapping
end

def draw_map
  $map.each do |x|
    x.each { |y| print y }
    print "\n"
  end
end

def part_1
  $map = []
  map_points(1)
end

def part_2
  $map = []
  map_points(2)
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end