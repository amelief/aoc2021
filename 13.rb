#!/usr/bin/env ruby

FILE = File.read('input/13.txt').split("\n\n").freeze

COORDS = FILE[0].split("\n").map(&:strip).freeze
FOLDS = FILE[1].split("\n").map(&:strip).freeze

FOLD_ALONG = /^fold along /.freeze
DOT = '#'.freeze

def construct_grid
  biggest_y = COORDS.map { |y| y.split(',').last.to_i }.sort.reverse.shift
  biggest_x = COORDS.map { |x| x.split(',').first.to_i }.sort.reverse.shift

  grid = Array.new(biggest_y + 1) { Array.new(biggest_x + 1, '.') }

  COORDS.each do |position|
    x, y = position.split(',').map(&:to_i)
    grid[y][x] = DOT
  end

  grid
end

def fold_grid(grid, fold_all = true)
  FOLDS.each_with_index do |fold, i|
    break if i > 0 && !fold_all
    fold = fold.gsub(FOLD_ALONG, '')
    fold_type, fold_at = fold.split('=').map(&:strip)

    grid = remap_grid(grid, fold_type, fold_at)
  end

  grid
end

def remap_grid(grid, fold_type, fold_at)
  if fold_type == 'y'
    grid_part_1 = grid.take(fold_at.to_i)
    grid_part_2 = grid.drop(fold_at.to_i + 1).reverse
  else
    grid_part_1 = grid.clone
    grid_part_2 = grid.clone

    grid.each.with_index do |data, row|
      grid_part_1[row] = data.take(fold_at.to_i)
      grid_part_2[row] = data.drop(fold_at.to_i + 1).reverse
    end
  end

  grid = grid_part_1.clone
  grid_part_1.each.with_index do |data, y|
    data.each.with_index do |char, x|
      grid[y][x] = DOT if grid_part_1[y][x] === DOT || grid_part_2[y][x] === DOT
    end
  end

  grid
end

def count_dots(grid)
  count = 0
  grid.each { |line| count += line.select { |s| s === DOT }.count }
  count
end

def draw_grid(grid)
  output = "\n"
  grid.each { |line| output << "#{line.join}\n" }
  output
end

def part_1
  count_dots(fold_grid(construct_grid, false))
end

def part_2
  draw_grid(fold_grid(construct_grid, true))
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end