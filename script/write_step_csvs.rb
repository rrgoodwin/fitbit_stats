require_relative "../models/step_day"
require_relative 'client_utils'

@from_filepath = "#{@root_filepath}/data/step_json/"
@to_filepath = "#{@root_filepath}/data/step_csv/"

def filename_for_day(day)
  "#{@to_filepath}/#{day.filename_root}.csv"
end

def write_csvs(force=false)
  Dir["#{@from_filepath}/*json"].each do |filename|
    day = StepDay.new(filename)

    puts "Writing #{filename_for_day(day)}"
    File.write(filename_for_day(day), day.csv)
  end
end

write_csvs
