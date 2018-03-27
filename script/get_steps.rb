require 'yaml'
require 'fitgem_oauth2/client.rb'
require 'rails' # TODO

require_relative 'client_utils'

@filepath = "#{@root_filepath}/data/step_json/"

@client = get_client
# refresh_token!(client) # use if my token has expired

# hrs = client.intraday_heartrate_time_series(start_date: Date.parse("2018-02-07"), end_date: Date.parse("2018-02-07"), detail_level: "1min", start_time: DateTime.parse("2018-02-07 00:00:00"), end_time: DateTime.parse("2018-02-07 23:59:59"))
# hrs["activities-heart-intraday"]["dataset"].map {|hr| [hr["time"], hr["value"]]}

def write_file_for_date(date)
  # date = DateTime.parse(datestring)
  puts "Getting step data for #{date}"
  steps = @client.intraday_activity_time_series(
    resource: "steps",
    start_date: date,
    end_date: date,
    detail_level: "1min",
    start_time: DateTime.parse("#{date.strftime("%Y-%m-%d")} 00:00:00"),
    end_time: DateTime.parse("#{date.strftime("%Y-%m-%d")} 23:59:59"))

  File.write(filename_for_date(date), steps.to_json)
end

def filename_for_date(date)
  "#{@filepath}#{date.strftime("%y%m%d")}.json"
end

# def convert_to_csv(json)
#   hrs = JSON.parse(json)
#   hrs["activities-heart-intraday"]["dataset"].map {|hr| "#{hr["time"]}, #{hr["value"]}"}.join("\n")
# end

@client = get_client

def get_data_for_date_range!(date_range)
  date_range.to_a.each do |date|
    date = date.to_date
    begin
      if !File.exist?(filename_for_date(date)) # || force
        write_file_for_date(date)
      end
    rescue => e
      puts e
    end
  end
end

def get_data!(force: false)
  date_range = if force
    date_range = @start_date...Date.today
  else
    latest_date = DateTime.parse(Dir["#{@filepath}/*"].max.scan(/\d{6}/).first) rescue @start_date # TODO
    date_range = latest_date...Date.today
  end

  get_data_for_date_range!(date_range)
end

# get_data_for_date_range!(2.days.ago.to_date..Date.yesterday.to_date) # test just yesterday
get_data!(force: true)

