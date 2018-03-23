require 'yaml'
require 'fitgem_oauth2/client.rb'
require 'rails' # TODO

# https://dev.fitbit.com/build/reference/web-api/oauth2/
# https://dev.fitbit.com/apps/oauthinteractivetutorial
# ^ I'm using authorization flow

@start_date = DateTime.parse("171202") # when I got the Charge
@root_filepath = "/Users/rebeccag/repositories/fitbit_stats"

def get_client
  secrets = YAML.load(File.read("#{@root_filepath}/secrets.yml"))
  client = FitgemOauth2::Client.new(
    client_id: secrets[:client_id],
    client_secret: secrets[:client_secret],
    token: secrets[:access_token])
end

def refresh_token!(client)
  secrets = YAML.load(File.read("secrets.yml"))

  response = client.refresh_access_token(secrets[:refresh_token])
  puts "response: #{response}"
  new_token = response["access_token"]
  puts "New token: #{new_token}"
  secrets[:access_token] = new_token
  `cp "#{@root_filepath}/secrets.yml" "#{@root_filepath}/secrets.yml.old"`
  File.write("#{@root_filepath}/secrets.yml", YAML.dump(secrets))

  client = get_client
end

# authorization url:
# https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=22CP5N&redirect_uri=https%3A%2F%2Fhr-data.herokuapp.com&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800

# curl -X POST -i -H 'Authorization: Basic MjJDUDVOOjI4MzkwMDIxMTkzYWQzMDhkY2I1M2ZkYjU4OTFlMzZi' -H 'Content-Type: application/x-www-form-urlencoded' -d "clientId=22CP5N" -d "grant_type=authorization_code" -d "redirect_uri=https%3A%2F%2Fhr-data.herokuapp.com" -d "code=34d80592ab54e96f55d7d5ad754845d388a2346b" https://api.fitbit.com/oauth2/token

