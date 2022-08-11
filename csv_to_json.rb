require 'json'

def parse_everything(csv)
  csv.each_line do |line|
    puts line
  end
end


if __FILE__ == $PROGRAM_NAME
  csv_file = ARGV[0]
  csv = File.read csv_file

  puts "creating new file: new_#{File.basename(csv_file, ".*")}.json"

  csv = File.open("new_#{File.basename(csv_file, ".*")}.csv", 'w')

  parse_everything(csv)
end