def get_lines(csv)
  csv_lines = []
  csv.each_line do |line|
    csv_lines.append line
  end
  csv_lines
end

def convert_to_data(string)
  return string.to_i if string.match(/^[0-9]*$/)
  return true if string.match(/^true$/i)
  return false if string.match(/^false$/i)
  return string
end

def depth(line)
  count = 1
  char = line[0]
  while char == ','
    count += 1
    char = line[count-1]
  end
  return count
end

def entries(line)
  data = line.strip.split(',').reject(&:empty?)
end

determine_type(lines, index)
  line = lines[index]
  next_line = lines[index + 1]
  case depth(next_line) - depth(line)
  when 2
    return Array
  when 1
    return Hash if entries(next_line).length == 2
    return Array
  when 0
    return String
  else
    p "didnt think of this #{line}"
  end
end

if __FILE__ == $PROGRAM_NAME
  csv_file = ARGV[0]
  csv = File.read csv_file

  puts "creating new file: new_#{File.basename(csv_file, ".*")}.json"

  json = File.open("new_#{File.basename(csv_file, ".*")}.json", 'w')

  lines = get_lines(csv)
  
  current_index = 0
  current_depth = 0
  current_object = nil
  structure = []
  
  lines.each_with_index do |line|
    while current_depth < line.depth
      current_object = determine_type()
  pp lines
end