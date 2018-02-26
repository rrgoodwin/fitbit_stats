require 'yaml'
require 'fitgem_oauth2/client.rb'
require 'rails' # TODO

require_relative 'client_utils'

@filepath = "#{@root_filepath}/data/sleep_json/"

client = get_client
# refresh_token!(client) # use if my token has expired

hrs = client.intraday_heartrate_time_series(start_date: Date.parse("2018-02-07"), end_date: Date.parse("2018-02-07"), detail_level: "1min", start_time: DateTime.parse("2018-02-07 00:00:00"), end_time: DateTime.parse("2018-02-07 23:59:59"))
hrs["activities-heart-intraday"]["dataset"].map {|hr| [hr["time"], hr["value"]]}



def write_file_for_date_range(start_date, end_date)
  puts "Getting sleep data for #{start_date} - #{end_date}"
  response = @client.sleep_logs_by_date_range(start_date, end_date)

  filename = filename_for_date_range(start_date, end_date)
  File.write(filename, response.to_json)

  write_daily_files_from_json(filename)
end

def write_daily_files_from_json(filename)
  # start_date = DateTime.parse(filename.scan(/\d{6}/).first)
  # end_date = DateTime.parse(filename.scan(/\d{6}/).last)

  json = JSON.parse(File.read(filename))
  sleeps = json["sleep"]

  sleeps.each do |this_sleep|
    date = DateTime.parse(this_sleep["dateOfSleep"])
    puts "Writing sleep data for #{date}"
    File.write(filename_for_date(date), this_sleep.to_json)
  end
end

def filename_for_date(date)
  "#{@filepath}#{date.strftime("%y%m%d")}.json"
end

def filename_for_date_range(start_date, end_date)
  "#{@filepath}/#{start_date.strftime("%y%m%d")}_#{end_date.strftime("%y%m%d")}.json"
end

# def convert_to_csv(json)
#   hrs = JSON.parse(json)
#   hrs["activities-heart-intraday"]["dataset"].map {|hr| "#{hr["time"]}, #{hr["value"]}"}.join("\n")
# end

@client = get_client

def get_data!(force: false)
  date_range = if force
    date_range = @start_date...Date.yesterday
  else
    latest_date = Dir["#{@filepath}/*_*.json"].max.scan(/\d{6}/).last rescue nil
    # latest_date = DateTime.parse(Dir["#{@filepath}/*"].max.scan(/\d{6}/).first) rescue @start_date # TODO
    date_range = latest_date...Date.yesterday
  end

  write_file_for_date_range(date_range.first, date_range.last)

  # date_range.to_a.each do |date|
  #   begin
  #     if !File.exist?(filename_for_date(date)) || force
  #       write_file_for_date(date)
  #     end
  #   rescue => e
  #     puts e
  #   end
  # end
end

get_data!
