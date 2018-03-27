require_relative 'client_utils'
require_relative '../models/heart_rate_day'

to_delete = Dir["#{@root_filepath}/data/heart_rate_json/*"].reject {|f| HeartRateDay.new(f).max_recorded_time == "23:59:00"}
to_delete.each do |f|
  puts "DELETING #{f} with max time: #{HeartRateDay.new(f).max_recorded_time}"
  File.delete(f)
end

puts "Done deleting incomplete files"