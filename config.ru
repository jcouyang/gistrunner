require 'rack'
require 'json'
require 'net/http'
app = proc do |env|
  gist = Net::HTTP.get(URI('https://gist.githubusercontent.com/jcouyang/7e32b3e4188236d7db39/raw'))
  response = {}
  response[:result] = eval(gist)
  response[:error] = 'none'
  [
    200,          # Status code
    {             # Response headers
      'Content-Type' => 'text/json',
    },
    [response.to_json]   # Response body
  ]
end

use Rack::CommonLogger
run app
