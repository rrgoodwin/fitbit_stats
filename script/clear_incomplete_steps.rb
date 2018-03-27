require_relative 'client_utils'
require_relative '../models/step_day'

to_delete = Dir["#{@root_filepath}/data/step_json/*"].reject {|f| StepDay.new(f).max_recorded_time == "23:59:00"}
to_delete.each do |f|
  puts "DELETING #{f} with max time: #{StepDay.new(f).max_recorded_time}"
  File.delete(f)
end

puts "Done deleting incomplete files"