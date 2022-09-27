require './value.rb'
require './field.rb'
require './record.rb'
require 'uri'

class Parser
  class << self
    
    def parse(stream, symbols)
      # puts 'chosing what to do next'
      unless stream.length == 0
        case stream[0]
        when ','
          # puts "parsing a field symbol"
          symbols.append Field.new
          return parse(stream[1..], symbols)
        when "\r"
          # puts "skipping \\r"
          return parse(stream[1..], symbols)
        when "\n"
          # puts "parsing a record symbol"
          symbols.append Record.new
          return parse(stream[1..], symbols)
        else
          return value_parse(stream, symbols)
        end
      end
      return symbols
    end
    
    def value_parse(stream, symbols)
      # puts "parsing a value, starting with the character: #{stream[0]"
      characters = []
      index = 0
      stream.each do |character|
        break if [",", "\n", "\r"].include?(character)
        index += 1
        characters.append character
      end
      value = characters.join('') 
      symbols.append Value.new(value)
      return parse(stream[index..], symbols)
    end
    
    def parse_file(csv_path)
      data = File.read(csv_path)
      pp data
      stream = data.each_char.map {|char| char unless char == ''}
      symbols = []
      symbols = parse(stream, symbols)
      pp symbols
      return symbols
    end
  end
  
end