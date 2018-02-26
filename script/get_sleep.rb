require 'yaml'
require 'fitgem_oauth2/client.rb'
require 'rails' # TODO

require_relative 'client_utils'
@filepath = "#{@root_filepath}/data/sleep_json/"

client = get_client
# refresh_token!(client) # use if my token has expired

# hrs = client.intraday_heartrate_time_series(start_date: Date.parse("2018-02-07"), end_date: Date.parse("2018-02-07"), detail_level: "1min", start_time: DateTime.parse("2018-02-07 00:00:00"), end_time: DateTime.parse("2018-02-07 23:59:59"))
# hrs["activities-heart-intraday"]["dataset"].map {|hr| [hr["time"], hr["value"]]}

def write_file_for_date(date)
  # date = DateTime.parse(datestring)
  puts "Getting sleep data for #{date}"
  sleeps = @client.sleep_logs(date)

  File.write(filename_for_date(date), sleeps.to_json)
end

def filename_for_date(date)
  "#{@filepath}#{date.strftime("%y%m%d")}.json"
end

# def convert_to_csv(json)
#   hrs = JSON.parse(json)
#   hrs["activities-heart-intraday"]["dataset"].map {|hr| "#{hr["time"]}, #{hr["value"]}"}.join("\n")
# end

@client = get_client

def get_data!(force=false)
  date_range = if force
    date_range = @start_date...Date.today
  else
    latest_date = DateTime.parse(Dir["#{@filepath}/*"].max.scan(/\d{6}/).first) rescue @start_date # TODO
    date_range = latest_date...Date.today
  end

  date_range.to_a.each do |date|
    begin
      if !File.exist?(filename_for_date(date)) || force
        write_file_for_date(date)
      end
    rescue => e
      puts e
    end
  end
end

get_data!
