require 'rack'
require 'rack/contrib'
require 'json'
require 'net/http'
require_relative 'lib/ruby_cop'
use Rack::JSONP
app = proc do |env|
  req = Rack::Request.new(env)
  path = req.path
  gist = Net::HTTP.get(URI("https://gist.githubusercontent.com#{path}/raw"))
  response = {}
  policy = RubyCop::Policy.new
  begin
    ast = RubyCop::NodeBuilder.build(gist)
    DATA = JSON.parse(req.POST)
    if ast.accept(policy)
      response[:result] = eval(gist)
      response[:error] = false
    else
      response[:result] = 'UNSAFE CODE!!'
      response[:error] = true
    end
  rescue SyntaxError => se
    response[:result] = se.to_s
    response[:error] = true
  end
  [
    200,          # Status code
    {             # Response headers
      'Content-Type' => 'application/json',
    },
    [response.to_json]   # Response body
  ]
end

use Rack::CommonLogger
run app
