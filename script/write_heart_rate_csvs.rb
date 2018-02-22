require_relative "../models/heart_rate_day"

@from_filepath = "data/heart_rate_json/"
@to_filepath = "data/heart_rate_csv/"

def filename_for_day(day)
  "#{@to_filepath}/#{day.filename_root}.csv"
end

def write_csvs(force=false)
  Dir["#{@from_filepath}/*json"].each do |filename|
    day = HeartRateDay.new(filename)

    puts "Writing #{filename_for_day(day)}"
    File.write(filename_for_day(day), day.heart_rate_csv)
  end
end

write_csvs
