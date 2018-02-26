require 'yaml'
require 'fitgem_oauth2/client.rb'
require 'rails' # TODO

# https://dev.fitbit.com/build/reference/web-api/oauth2/
# https://dev.fitbit.com/apps/oauthinteractivetutorial

@start_date = DateTime.parse("171202") # when I got the Charge
@root_filepath = "/Users/rebeccag/repositories/fitbit_stats"

def get_client
  secrets = YAML.load(File.read("secrets.yml"))
  client = FitgemOauth2::Client.new(
    client_id: secrets[:client_id],
    client_secret: secrets[:client_secret],
    token: secrets[:access_token])
end

def refresh_token!(client)
  secrets = YAML.load(File.read("secrets.yml"))
  response = client.refresh_access_token(secrets[:refresh_token])
  new_token = response["access_token"]
  secrets[:access_token] = new_token
  File.write("secrets.yml", YAML.dump(secrets))

  client = get_client
end

