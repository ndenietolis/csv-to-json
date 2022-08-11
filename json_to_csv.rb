require 'json'

def print_data(data, csv, count)

  data.each do |key, value|
    value = 'null' if value.nil?
    val = 'unchanged'
    
    case
    when value.class == Hash
      val = '{'
    when value.class == Array
      val = '['
    else
      val = value
    end

    csv.write ["," * count, (key if key.class != Hash && key.class != Array), "," , val, "\n"].join('')
    begin
      get_everything(data[key], csv, count + 1)
    rescue 
      if value.class == Array
        value.each do |data|
          csv.write ["," * (count + 1), data, "\n"].join('')
        end
      end
      next
    end
  end
end

def get_everything(data, csv, count=0)

  case 
  when data.class == Hash
  when data.class == Array
    data.each do |data|
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  json_file = ARGV[0]
  json = File.read json_file
  json_data = JSON.parse json

  puts "creating new file: #{File.basename(json_file, ".*")}.csv"

  csv = File.open("#{File.basename(json_file, ".*")}.csv", 'w')

  get_everything(json_data, csv)
end