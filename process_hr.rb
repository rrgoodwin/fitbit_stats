all_hrs = Dir["data/*json"].sort.map do |filename|
  day = HeartRateDay.new(filename)
  day.heart_rate_csv
end.flatten.join("\n")

File.write("all.csv", all_hrs)