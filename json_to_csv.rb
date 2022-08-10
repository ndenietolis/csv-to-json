require 'json'

json_file = ARGV[0]

json = File.read json_file

json_data = JSON.parse json

pp json_data

end
