require_relative '../script/client_utils'
require_relative '../models/step_day'

@filepath = "#{@root_filepath}/data/step_json/"
Dir["#{@filepath}/*"].select do |filename|
  StepDay.new(filename).dataset.map {|json| json["value"]}.sum <= 0
end.each do |filename|
  puts "DELETING #{filename}"
  File.delete(filename)
end
