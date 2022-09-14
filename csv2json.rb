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
    data = entries(line)
    p data
    p depth(line)
    # level = depth(line)
    # data = entries(line)[0]
    # type = entries(line)[1]
    # structure[level] = data[0] 
  end
end

def convert_to_data(string)
  return string.to_i if string.match(/^[0-9]*$/)
  return true if string.match(/^true$/i)
  return false if string.match(/^false$/i)
  return string
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

def subset_lines(lines, depth = 0)
  subset = []
  lines[1..].each do |line|
    return subset if depth(line) < depth
    subset.append line if depth(line) == depth + 1
  end
  return subset
end

def print_subsets(lines)
  subset = subset_lines lines
  return if subset == []
  pp subset
  p '######################################################################'
  print_subsets subset
end

# for ititial typing of object
def determine_type(lines, index)
  line = lines[index]
  next_line = lines[index + 1]
  case depth(next_line) - depth(line)
  when 1
    return Hash if entries(next_line).length == 2
    return Array
  when 0
    return String
  else
    p "didnt think of this #{line}"
  end
end
  
# def parse_lines(lines, obj, depth = 0)
#   lines.each_with_index do |line, index|
#     next_line = lines[index + 1]
#     case depth(next_line) - depth(line)
#     when 0
#       obj      
#     when 1
#       if entries(next_line).length == 2
#         obj = Hash.new
#       else #if next_line.entries.length == 1
#         obj = Array.new
#       end
#     when 2
#       obj = Array.new
#       parse_lines(lines, depth + 1)
#     end
#   end
# end

def parse_lines(lines, obj, depth = 0)
  subset = subset_lines(lines, depth)
  lines.each_with_index do |line, index|
    p line
    if depth(lines[index + 1]) > depth(line)
      parse_lines(subset, obj, depth(lines[index + 1]))
    end
    next
  end
end

  
if __FILE__ == $PROGRAM_NAME
  csv_file = ARGV[0]
  csv = File.read csv_file

  puts "creating new file: new_#{File.basename(csv_file, ".*")}.json"

  json = File.open("new_#{File.basename(csv_file, ".*")}.json", 'w')

  # build_data(csv)
  lines = get_lines(csv)
  new_obj = determine_type(lines, 0).new
  parse_lines(lines, new_obj)
end