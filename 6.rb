#!/usr/bin/env ruby
FILE = File.read('input/6.txt').split(',').map(&:to_i)

# For part 1 only
def simple_count_fish(count)
  current_fish_list = FILE.clone

  count.times do
    current_fish_list.each_with_index do |fish, i|
      if fish == 0
        current_fish_list[i] = 6
        current_fish_list << 9
      else
        current_fish_list[i] = fish - 1
      end
    end
  end

  current_fish_list.count
end

def count_fish(count)
  fish_list = []
  10.times { |n| fish_list[n] = 0 }

  FILE.each do |fish|
    fish_list[fish] += 1
  end

  count.times do
    fish_list[7] += fish_list[0]
    fish_list[9] = fish_list[0] if fish_list[0] > 0

    0.upto(8) do |i|
      fish_list[i] = fish_list[i + 1]
    end

    fish_list[9] = 0
  end

  fish_list.sum
end

def part_1
  count_fish(80)
end

def part_2
  count_fish(256)
end


1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end