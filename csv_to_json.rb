require 'json'

def get_lines(csv)
  csv_lines = []
  csv.each_line do |line|
    csv_lines.append line
  end
  csv_lines
end

def build_data(csv)
  json_object = {}
  structure = {}

  lines = get_lines(csv)
  lines.each do |line|
    level = depth(line)
    data = entries(line)
    structure[level] = data(line)[0] 
    pp structure
  end

end

def depth(line)
  count = 0
  char = line[0]
  while char == ','
    count += 1
    char = line[count]
  end
  return count
end

def entries(line)
  data = line.strip.split(',').reject(&:empty?)
end


if __FILE__ == $PROGRAM_NAME
  csv_file = ARGV[0]
  csv = File.read csv_file

  puts "creating new file: new_#{File.basename(csv_file, ".*")}.json"

  json = File.open("new_#{File.basename(csv_file, ".*")}.json", 'w')

  build_data(csv)
end