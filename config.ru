require 'rack'
require 'json'
require 'net/http'
app = proc do |env|
  req = Rack::Request.new(env)
  path = req.path  
  gist = Net::HTTP.get(URI("https://gist.githubusercontent.com#{path}/raw"))
  response = {}
  begin
    response[:result] = eval(gist)
    response[:error] = false
  rescue SyntaxError => se
    response[:result] = se.to_s
    response[:error] = true
  ensure
    response[:error] = true
  end
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
