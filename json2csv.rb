require 'json'

def parse_data(data, csv, count = -1)
  count += 1 
  case data
  when Hash
    data.each do |key, value|
      value = 'null' if value.nil?
      case value
      when Hash
        write_data key, csv, count
        parse_data value, csv, count
      when Array
        write_data key, csv, count
        parse_data value, csv, count
      else 
        # p "#{key},#{value}"
        line = "#{key},#{value}"
        write_data line, csv, count
      end
      
    end
  when Array
    # do array things
    data.each do |datum|
      if datum.class == Hash
        parse_data datum, csv, count
      else
        parse_data datum, csv, count - 1
      end
    end
  when String || Integer
    # do string things, lol
    data = 'null' if data.nil?
    write_data data, csv, count
  end
end
  
def write_data(data, csv, count)
  csv.write ["," * count, data, "\n"].join('')
end

if __FILE__ == $PROGRAM_NAME
  json_file = ARGV[0]
  json = File.read json_file
  json_data = JSON.parse json

  puts "creating new file: #{File.basename(json_file, ".*")}.csv"
  csv = File.open("#{File.basename(json_file, ".*")}.csv", 'w')
  parse_data(json_data, csv)
end