#!/usr/bin/env ruby

FILE = File.read('input/14.txt').split("\n\n").freeze
TEMPLATE = FILE[0].strip.freeze

RULES = FILE[1].split("\n").map(&:strip).freeze

def inserted_char(rule)
  extract_rule(rule)[1]
end

def extract_rule(rule)
  rule.split('->').map(&:strip)
end

def make_regex_from_rule(rule)
  char_sequence, insert = extract_rule(rule)
  insert = "#{char_sequence[0]}#{insert}#{char_sequence[1]}"
  char_sequence = /#{char_sequence}/
  [char_sequence, insert]
end

def find_rule_for(chars)
  rules = RULES.select { |rule| extract_rule(rule)[0] == chars }
  rules.any? ? rules.first : nil
end

def apply_rule(rule, chars)
  char_sequence, insert = make_regex_from_rule(rule)

  new_chars = chars.gsub(char_sequence, insert)
end

def count_chars(chars)
  char_count = []
  chars.split('').uniq.each { |char| char_count << chars.count(char) }
  
  [char_count.max, char_count.min]
end

def simple_run(times)
  template = TEMPLATE.dup

  times.times do
    new_template = ''

    template.each_char.with_index do |char, i|
      chars = "#{template[i]}#{template[i + 1]}"
      if chars.length < 2
        new_template << char
        break
      end

      rule = find_rule_for(chars)
      if rule
        new_template << apply_rule(rule, chars)[0..1]
      else
        new_template << char
      end
    end
    template = new_template
  end

  most, least = count_chars(template)
  most - least
end

def better_run(times)
  template = TEMPLATE.dup
  template_parts = {}
  char_count = {}

  template.each_char.with_index do |char, i|
    char_count[char] ||= 0
    char_count[char] += 1

    next if i === 0
    
    previous_char_position = i - 1
    previous_char_position = nil if previous_char_position < 0

    previous_char = template[previous_char_position] rescue nil
    
    if previous_char
      template_parts["#{previous_char}#{char}"] ||= 0
      template_parts["#{previous_char}#{char}"] += 1
    end
  end

  times.times do |j|
    current_template = template_parts.dup

    template_parts.each do |key, value|
      next if value < 1
      rule = find_rule_for(key)
      
      if rule
        new_key = apply_rule(rule, key)
        new_char = inserted_char(rule)
        char_count[new_char] ||= 0
        current_template[new_key[0..1]] ||= 0
        current_template[new_key[1..2]] ||= 0

        char_count[new_char] += value

        current_template[new_key[0..1]] += value
        current_template[new_key[1..2]] += value

        current_template[key] -= value
      end
    end

    template_parts = current_template
  end

  char_count.reject! { |k,v| v === 0 }
  sorted = char_count.sort_by { |key, value| -value }
  sorted.first.last - sorted.last.last
end
  

def part_1
  simple_run(10)
end

def part_2
  better_run(40)
end

1.upto(2) do |part|
  puts "Part #{part}: #{send("part_#{part}")}"
end