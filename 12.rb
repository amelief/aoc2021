#!/usr/bin/env ruby

FILE = File.readlines('input/12.txt').map(&:strip).freeze

BIG_CAVE = /[A-Z]{1,2}/.freeze
SMALL_CAVE = /[a-z]{1,2}/.freeze
START_POINT = 'start'.freeze
END_POINT = 'end'.freeze

def next_path_for(endpoint, array)
  paths = all_paths_for(endpoint, array))
  while paths.any?
    if paths.size > 1
      $total_paths << path_up_to_here.clone
    end
    value = paths.shift
  end
  [value, array - value]
end

def all_paths_for(endpoint, array)
  array.select { |path| path.split('-').first.match(/^#{endpoint}$/) }
end

def select_path_for(endpoint, array)
  current_pathway = []
  next_path, array = next_path_for(endpoint, array)
  while(next_path != END_POINT) do
    current_pathway << next_path

    next_path, array = next_path_for(array)
  end
  current_pathway
end



def part_1
  paths = []
  final_paths = []

  remaining_paths = FILE.clone.map(&:clone)

  base_paths = remaining_paths.select { |path| path.start_with?(START_POINT) }
  remaining_paths -= base_paths

  unique_parts = []
  FILE.each do |part|
    possible_paths = all_paths_for(part.split('-').last, FILE)



    starting_points = 
  end

  
  while remaining_paths.any?
    paths = base_paths.clone.map(&:clone)
    paths.map! { |x| [x] }

    paths.each.with_index do |path, i|
      current_instruction = path.split('-').last

      all_paths_for_this_path = all_paths_for(current_instruction, remaining_paths)
      all_paths_for_this_path.each do
        paths << paths[i].clone
      end


      remaining_paths -= all_paths


 



  puts paths.inspect
  puts final_paths.inspect


      # Go through the remaining paths

      
end

def part_2
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end