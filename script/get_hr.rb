require 'yaml'
require 'fitgem_oauth2/client.rb'
require 'rails' # TODO
# https://dev.fitbit.com/build/reference/web-api/oauth2/
# https://dev.fitbit.com/apps/oauthinteractivetutorial

@filepath = "../data/heart_rate_json/"


def get_client
  secrets = YAML.load(File.read("secrets.yml"))
  client = FitgemOauth2::Client.new(
    client_id: secrets[:client_id],
    client_secret: secrets[:client_secret],
    token: secrets[:access_token])
end

def refresh_token!(client)
  new_token = client.refresh_access_token(secrets[:refresh_token])["access_token"]
  secrets[:access_token] = new_token
  File.write("secrets.yml", YAML.dump(secrets))

  client = get_client
end


client = get_client
# response = client.heart_rate_time_series(start_date: 1.month.ago, end_date: Date.yesterday)
# hrs = response["activities-heart"]

# # intraday_heart_rate_time_series(start_date: nil, end_date: nil, detail_level: nil, start_time: nil, end_time: nil)
# client.intraday_heart_rate_time_series(start_date: Date.parse("2018-02-07"), end_date: Date.parse("2018-02-08"), detail_level: "1min", start_time: DateTime.parse("2018-02-07 00:00:00"), end_time: DateTime.parse("2018-02-08 00:00:00"))

hrs = client.intraday_heart_rate_time_series(start_date: Date.parse("2018-02-07"), end_date: Date.parse("2018-02-07"), detail_level: "1min", start_time: DateTime.parse("2018-02-07 00:00:00"), end_time: DateTime.parse("2018-02-07 23:59:59"))
hrs["activities-heart-intraday"]["dataset"].map {|hr| [hr["time"], hr["value"]]}

def write_file_for_date(date)
  # date = DateTime.parse(datestring)
  puts "Getting data for #{date}"
  hrs = @client.intraday_heart_rate_time_series(
    start_date: date,
    end_date: date,
    detail_level: "1min",
    start_time: DateTime.parse("#{date.strftime("%Y-%m-%d")} 00:00:00"),
    end_time: DateTime.parse("#{date.strftime("%Y-%m-%d")} 23:59:59"))

  File.write(filename_for_date(date), hrs.to_json)
end

def filename_for_date(date)
  "#{@filepath}#{date.strftime("%y%m%d")}.json"
end

def convert_to_csv(json)
  hrs = JSON.parse(json)
  hrs["activities-heart-intraday"]["dataset"].map {|hr| "#{hr["time"]}, #{hr["value"]}"}.join("\n")
end

@client = get_client
# JSON.parse(File.read("data/180207.json"))
# write_file_for_date("2018-02-6")

def get_data!(force=false)
  date_range = if force
    date_range = 3.months.ago.to_date...Date.today
  else
    latest_date = DateTime.parse(Dir["#{@filepath}/*"].max.scan(/\d{6}/).first)
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
