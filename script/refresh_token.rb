require_relative 'client_utils'

client = get_client
refresh_token!(client) # use if my token has expired