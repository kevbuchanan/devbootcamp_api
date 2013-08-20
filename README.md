#Socrates API
This app serves as the api to the socrates database.
The DBc shared token must be configured as an environment variable to authorize requests for API keys from the [dev app](https://github.com/socrates-api/dev).
```ruby
ENV['DBC_SHARED'] = 'DBC-SHARED' + # the dbc shared token for api key requests
```
